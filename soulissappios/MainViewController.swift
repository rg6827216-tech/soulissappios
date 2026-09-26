//
//  ViewController.swift
//  soulissappios
//
//  Created by Hatem Alimam on 31/08/15.
//  Copyright (c) 2015 Souliss. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SocketerDelegate {

    @IBOutlet weak var testBtn: UIButton!
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var responseTextView: UITextView!

    var socketer: Socketer?
    private var pendingPayload: Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    static func shouldCreateNewSocketer(currentIP: String?, currentCanBeReused: Bool, targetIP: String) -> Bool {
        currentIP != targetIP || !currentCanBeReused
    }

    @IBAction func sendAction(_ sender: Any) {
        guard
            let ipAddressText = ipAddressTextField.text,
            let ip = NetUtils().splitIPv4(ip: ipAddressText)
        else {
            let alertController = UIAlertController(
                title: "Souliss",
                message: "You need to specify a valid IP",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            present(alertController, animated: true)
            return
        }

        let endMarker = Data([0xc, 0xb, 0x17, ip.fourth, ip.third, 0x6, 0x5, 0x8, 0xb1, 0x0, 0x0, 0x0])
        if Self.shouldCreateNewSocketer(
            currentIP: socketer?.IP,
            currentCanBeReused: socketer?.canBeReused ?? false,
            targetIP: ipAddressText
        ) {
            pendingPayload = endMarker
            socketer?.closeConnection()
            socketer = Socketer(socketerDelegate: self, IP: ipAddressText)
        } else {
            socketer?.send(data: endMarker)
        }
        view.endEditing(true)
    }

    func didConnect() {
        responseTextView.text = responseTextView.text + "\nDid Connect"
        if let pendingPayload {
            socketer?.send(data: pendingPayload)
            self.pendingPayload = nil
        }
    }

    func didSend() {
        responseTextView.text = responseTextView.text + "\nDid Send"
    }

    func didReceiveData(_ data: Data) {
        responseTextView.text = responseTextView.text + "\ndidReceiveData: \(data)"
    }

    func didNotConnect() {
        pendingPayload = nil
        responseTextView.text = responseTextView.text + "\nDid not Connect !"
    }

    func didNotSend() {
        responseTextView.text = responseTextView.text + "\nDid not Send !"
    }
}
