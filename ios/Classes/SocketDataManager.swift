//
//  SocketDataManager.swift
//  print_plugin
//
//  Created by test on 11/03/2022.
//

import Foundation

class SocketDataManager: NSObject, StreamDelegate {
    
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    var inputStream: InputStream?
    var outputStream: OutputStream?
    var messages = [AnyHashable]()
    
    func connectWith(ip: String, port: Int) {

        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (ip as CFString), UInt32(port), &readStream, &writeStream)
        messages = [AnyHashable]()
        open()
    }
    
    func disconnect(){
        close()
    }
    
    func open() {
        print("Opening streams.")
        outputStream = writeStream?.takeRetainedValue()
        inputStream = readStream?.takeRetainedValue()
        outputStream?.delegate = self
        inputStream?.delegate = self
        outputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        inputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream?.open()
        inputStream?.open()
    }
    
    func close() {
        print("Closing streams.")
        inputStream?.close()
        outputStream?.close()
        inputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        outputStream?.remove(from: RunLoop.current, forMode: RunLoop.Mode.default)
        inputStream?.delegate = nil
        outputStream?.delegate = nil
        inputStream = nil
        outputStream = nil
    }
    
    
    func send(message: String){
        let buff = [UInt8](message.utf8)
        outputStream?.write(buff, maxLength: buff.count)

    }

}
