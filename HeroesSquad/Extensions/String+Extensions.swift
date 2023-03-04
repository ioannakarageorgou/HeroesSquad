//
//  String+Extensions.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 17/2/23.
//

import Foundation
import CryptoKit

extension String {
    var md5: String {
        let hash = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
