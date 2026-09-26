//
//  InSocket.swift
//  soulissappios
//
//  Created by Hatem Alimam on 01/09/15.
//  Copyright (c) 2015 Souliss. All rights reserved.
//

import CocoaAsyncSocket
import Foundation

class Socketer: NSObject, GCDAsyncUdpSocketDelegate {

    var IP = ""
    let PORT: UInt16 = 230
    var socket: GCDAsyncUdpSocket!
    var socketerDelegate: SocketerDelegate

    init(socketerDelegate intiSocketerDelegate: SocketerDelegate, IP: String) {
        socketerDelegate = intiSocketerDelegate
        self.IP = IP
        super.init()
        setupConnection()
    }

    func setupConnection() {
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
        do {
            try socket.bind(toPort: PORT)
            try socket.connect(toHost: IP, onPort: PORT)
            try socket.beginReceiving()
        } catch {
            print("Socket setup failed: \(error)")
        }
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        print("incoming message: \(data)")
        socketerDelegate.didReceiveData(data)
    }

    func send(data: Data) {
        socket.send(data, withTimeout: 2, tag: 0)
        print("localAddress is: \(String(describing: socket.localAddress()))")
        print("localHost is: \(String(describing: socket.localHost()))")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("didConnectToAddress")
        socketerDelegate.didConnect()
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("didNotConnect \(String(describing: error))")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
        socketerDelegate.didSend()
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotSendDataWithTag tag: Int, dueToError error: Error?) {
        print("didNotSendDataWithTag")
        socketerDelegate.didNotSend()
    }
}
