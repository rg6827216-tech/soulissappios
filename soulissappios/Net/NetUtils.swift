//
//  NetUtils.swift
//  soulissappios
//
//  Created by Hatem Alimam on 29/09/15.
//  Copyright © 2015 Souliss. All rights reserved.
//

import Foundation

class NetUtils {

    func splitIPv4(ip: String) -> (first: UInt8, second: UInt8, third: UInt8, fourth: UInt8)? {
        let components = ip.split(separator: ".")
        guard components.count == 4 else {
            return nil
        }

        let octets = components.compactMap { UInt8($0) }
        guard octets.count == 4 else {
            return nil
        }

        return (octets[0], octets[1], octets[2], octets[3])
    }
}
