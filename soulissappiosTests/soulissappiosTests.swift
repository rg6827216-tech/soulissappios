//
//  soulissappiosTests.swift
//  soulissappiosTests
//
//  Created by Hatem Alimam on 31/08/15.
//  Copyright (c) 2015 Souliss. All rights reserved.
//

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
                currentIsUsable: false,
                targetIP: "192.168.0.1"
            )
        )
    }

    func testShouldCreateNewSocketerWhenTargetIPChanges() {
        XCTAssertTrue(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentIsUsable: true,
                targetIP: "192.168.0.11"
            )
        )
    }

    func testShouldCreateNewSocketerWhenCurrentSocketIsUnusable() {
        XCTAssertTrue(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentIsUsable: false,
                targetIP: "192.168.0.10"
            )
        )
    }

    func testShouldReuseSocketerWhenTargetIPMatchesAndSocketIsUsable() {
        XCTAssertFalse(
            MainViewController.shouldCreateNewSocketer(
                currentIP: "192.168.0.10",
                currentIsUsable: true,
                targetIP: "192.168.0.10"
            )
        )
    }

    func testPerformanceExample() {
        measure {
        }
    }
}
