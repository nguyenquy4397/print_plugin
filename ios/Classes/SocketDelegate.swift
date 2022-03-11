//
//  SocketDelegate.swift
//  print_plugin
//
//  Created by test on 11/03/2022.
//

import Foundation

protocol SocketDelegate: AnyObject {
    /**
     Called when `StreamDelegate` calls `stream(,eventCode)` with `.hasBytesAvailable` after all bytes have been read into a `Data` instance.
     
     - Parameter result: `Data` result from InputStream.
     */
    func socketDataReceived(result: Data?)
    
    /**
     Called when `StreamDelegate` calls `stream(,eventCode)` with `.hasBytesAvailable` after all bytes have been read into a `Data` instance and it was nil.
     */
    func receivedNil()
}
