//
//  CryptPassUtils.swift
//  movie_booking
//
//  Created by Andrei-Alexandru Pasca on 29.01.2025.
//
import CryptoKit
import Foundation

final class CryptPassUtils {

    private static let key: UInt8 = 0xAB 

    public static func encryptPassword(input: String) -> String? {
        guard let data = input.data(using: .utf8) else { return nil }
        let encryptedData = data.map { $0 ^ key }
        return String(bytes: encryptedData, encoding: .utf8)
    }
}
