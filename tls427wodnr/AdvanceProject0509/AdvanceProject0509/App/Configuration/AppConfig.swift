//
//  AppConfig.swift
//  AdvanceProject0509
//
//  Created by tlswo on 5/9/25.
//

import Foundation

// MARK: - AppConfig

enum AppConfig {

    // MARK: - API Keys

    static var clientID: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLIENT_ID") as? String else {
            fatalError("CLIENT_ID is missing in Info.plist")
        }
        return value
    }

    static var clientSecret: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "CLIENT_SECRET") as? String else {
            fatalError("CLIENT_SECRET is missing in Info.plist")
        }
        return value
    }
}
