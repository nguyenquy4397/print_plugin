//
//  SocketServer.swift
//  print_plugin
//
//  Created by test on 11/03/2022.
//

import Foundation

class SocketServer: NSObject{
    
    static private let HOST = "172.29.4.213"
    static private let PORT: UInt32 = 9100
    
    //Server action code
    static public let SOME_ACTION: UInt8 = 100

    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    
    public var isOpen: Bool = false
    weak var delegate: SocketDelegate?
    
    override init(){
        super.init()
    }
    
    //1
    public func connect(){
        //set up uninitialized socket streams
        //  without automatic memory management
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        //bind read and write socket streams
        //  together and connect them to the socket of the host
        CFStreamCreatePairWithSocketToHost(
                             kCFAllocatorDefault,
                             SocketServer.HOST as CFString,
                             SocketServer.PORT,
                             &readStream,
                             &writeStream)
        
        
        //store retained references
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self
        //run a loop
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)

        //open flood gates
        inputStream.open()
        outputStream.open()
        
        isOpen = true
    }
    
    //2
    private func closeNetworkConnection(){
        inputStream.close()
        outputStream.close()
        isOpen = false
    }
    
    //3
    private func serverRequest(serverActionCode: UInt8, int: UInt8){
        writeToOutputStream(int: serverActionCode)
        writeToOutputStream(int: int)
    }
    
    //4
    public func someAction(someParam: UInt8!){
        serverRequest(serverActionCode: SocketServer.SOME_ACTION, int: someParam)
    }
}

extension SocketServer: StreamDelegate{
    
    //Delegate method override
    func stream(_ aStream: Stream, handle eventCode: Stream.Event){
        switch eventCode{
        case .hasBytesAvailable:
            //inputStream has something to pass
            let s = self.readStringFrom(stream: aStream as! InputStream)
            self.closeNetworkConnection()
            if let s = s{
                self.delegate?.socketDataReceived(result: Data(s.utf8))
            }else{
                self.delegate?.receivedNil()
            }
        case .endEncountered:
            print("end of inputStream")
        case .errorOccurred:
            print("error occured")
        case .hasSpaceAvailable:
            print("has space available")
        case .openCompleted:
            isOpen = true
            print("open completed")
        default:
            print("StreamDelegate event")
        }
    }
    
    //1
    private func getBufferFrom(stream: InputStream, size: Int) -> UnsafeMutablePointer<UInt8> {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
        
        while (stream.hasBytesAvailable) {
            let numberOfBytesRead = self.inputStream.read(buffer, maxLength: size)
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            if numberOfBytesRead == 0{
                //EOF
                break
            }
        }
        return buffer
    }
    
    //2
    private func readDataFrom(stream: InputStream, size: Int) -> Data?{
        let buffer = getBufferFrom(stream: stream, size: size)
        return Data(bytes: buffer, count: size)
    }
    
    //3
    private func readStringFrom(stream: InputStream, withSize: Int) -> String?{
        let d = readDataFrom(stream: stream, size: withSize)!
        return String(data: d, encoding: .utf8)
    }
    
    //4
    private func readStringFrom(stream: InputStream) -> String?{
        let len: Int = Int(Int32(readIntFrom(stream: inputStream)!))
        return readStringFrom(stream: stream, withSize: len)
    }
    
    //5
    private func readIntFrom(stream: InputStream) -> UInt32?{
        let buffer = getBufferFrom(stream: stream, size: 4)
        var int: UInt32 = 0
        let data = NSData(bytes: buffer, length: 4)
        data.getBytes(&int, length: 4)
        int = UInt32(bigEndian: int)
        buffer.deallocate()
        return int
    }
    
    //6
    private func writeToOutputStream(string: String){
        let data = string.data(using: .utf8)!
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    //7
    private func writeToOutputStream(int: UInt8){
        let data = Data([int])
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self)
            else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
}
