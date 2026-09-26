//
//  soulissappiosTests.swift
//  soulissappiosTests
//
//  Created by Hatem Alimam on 31/08/15.
//  Copyright (c) 2015 Souliss. All rights reserved.
//

import UIKit
import XCTest
@testable import soulissappios

final class soulissappiosTests: XCTestCase {

    func testSplitIPv4ParsesFourOctets() {
        let result = NetUtils().splitIPv4(ip: "192.168.0.1")

        XCTAssertEqual(result?.first, 192)
        XCTAssertEqual(result?.second, 168)
        XCTAssertEqual(result?.third, 0)
        XCTAssertEqual(result?.fourth, 1)
    }

    func testSplitIPv4RejectsInvalidAddresses() {
        XCTAssertNil(NetUtils().splitIPv4(ip: ""))
        XCTAssertNil(NetUtils().splitIPv4(ip: "192.168.0"))
        XCTAssertNil(NetUtils().splitIPv4(ip: "192.168.0.999"))
    }

    func testShouldCreateNewSocketerWhenNoSocketExists() {
        XCTAssertTrue(
            MainViewController.shouldCreateNewSocketer(
                currentIP: nil,
                currentCanBeReused: false,
                targetIP: "192.168.0.1"
            )
        )
    }

    func testShouldCreateNewSocketerWhenTargetIPChanges() {
        XCTAssertTrue(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentCanBeReused: true,
                targetIP: "192.168.0.11"
            )
        )
    }

    func testShouldCreateNewSocketerWhenCurrentSocketIsUnusable() {
        XCTAssertTrue(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentCanBeReused: false,
                targetIP: "192.168.0.10"
            )
        )
    }

    func testShouldReuseSocketerWhenTargetIPMatchesAndSocketIsUsable() {
        XCTAssertFalse(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentCanBeReused: true,
                targetIP: "192.168.0.10"
            )
        )
    }

    func testDidNotConnectAppendsFailureMessage() {
        let viewController = MainViewController()
        viewController.responseTextView = UITextView()
        viewController.pendingPayload = Data([0x01])

        viewController.didNotConnect()

        XCTAssertNil(viewController.pendingPayload)
        XCTAssertEqual(viewController.responseTextView.text, "\nDid not Connect !")
    }

    func testDidSendAppendsSuccessMessage() {
        let viewController = MainViewController()
        viewController.responseTextView = UITextView()

        viewController.didSend()

        XCTAssertEqual(viewController.responseTextView.text, "\nDid Send")
    }

    func testDidNotSendAppendsFailureMessage() {
        let viewController = MainViewController()
        viewController.responseTextView = UITextView()
        viewController.pendingPayload = Data([0x01])

        viewController.didNotSend()

        XCTAssertNil(viewController.pendingPayload)
        XCTAssertEqual(viewController.responseTextView.text, "\nDid not Send !")
    }

    func testDidConnectConsumesPendingPayload() {
        let viewController = MainViewController()
        viewController.responseTextView = UITextView()
        viewController.pendingPayload = Data([0x01])

        viewController.didConnect()

        XCTAssertNil(viewController.pendingPayload)
        XCTAssertEqual(viewController.responseTextView.text, "\nDid Connect")
    }

    func testPerformanceExample() {
        measure {
        }
    }
}
