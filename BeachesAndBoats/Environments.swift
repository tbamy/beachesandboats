//
//  Environments.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/08/2024.
//

import Foundation
import Moya

enum Environment {
    case Mock
    case Dev
    case Release
}

enum Configuration {
    static var isQAMode = false
    static let environment: Environment = {
        
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            switch configuration.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "Debug(Mock)":
                return Environment.Mock
            case "Debug(Dev)":
                return Environment.Dev
            default:
                return Environment.Release
            }
        }
        return Environment.Release
    }()
    
    
    static let fixedEnv: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            switch configuration.trimmingCharacters(in: .whitespacesAndNewlines) {
            case "Debug(Mock)":
                clearQAData()
                return Environment.Mock
            case "Debug(Dev)":
                clearQAData()
                return Environment.Dev
            case "Release":
                clearQAData()
                return Environment.Release
            default:
                return Environment.Release
            }
        }
        return Environment.Release
    }()
    
    static let baseURLString: String = {
        switch environment {
        case .Dev:
            return "https://benbsbackend.etogetherness.com/"
        case .Mock:
            return "https://benbsbackend.etogetherness.com/"
        case .Release:
            return "https://benbsbackend.etogetherness.com/"
        }
    }()
    
    static let baseURL: URL = {
        guard let baseURL = URL(string: baseURLString) else {
            fatalError("Couldn't conver base url string to URL")
        }
        return baseURL
    }()
    
    static var headers: [String:String] {
        return ["Content-Type": "application/json"]
    }
    
    static let stubBehavior: StubBehavior = {
        if environment == .Mock {
            return .delayed(seconds: 2.0)
        }
        return .never
    }()
    
    static private func clearQAData() {
        AppStorage.environment = nil
    }
    
    
        
}
