//
//  CustomSocket.swift
//  print_plugin
//
//  Created by test on 09/03/2022.
//

import Foundation

class CustomSocket : NSObject {
    var data: [Int]
    var ip: String
    var port: Int
    var task: URLSessionStreamTask!
    
    init(data: [Int], ip: String, port: Int){
        self.data = data
        self.ip = ip
        self.port = port
    }
    
    public func connect(){
        let session = URLSession(configuration: .default)
        task = session.streamTask(withHostName: ip, port: port)
        self.task.resume()
    }
    
    public func sendData(){
        let toData = withUnsafeBytes(of: self.data) {Data($0)}
        self.task.write(toData, timeout: 10) { (error) in
                    if error == nil {
                        print("Data sent")
                    } else {
                        print("Nope")
                    }
                }
    }

}
