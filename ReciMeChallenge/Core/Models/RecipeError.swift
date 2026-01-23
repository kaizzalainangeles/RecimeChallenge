//
//  RecipeError.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/23/26.
//

import Foundation

enum RecipeError: Error, LocalizedError {
    case connectionFailed
    case decodingError(String)
    case persistenceFailure(String)
    case imageSaveFailed

    var errorDescription: String? {
        switch self {
        case .connectionFailed: return "Could not connect to the server. Please check your internet."
        case .decodingError(let details): return "Data format error: \(details)"
        case .persistenceFailure(let msg): return "Database error: \(msg)"
        case .imageSaveFailed: return "We couldn't save your recipe photo."
        }
    }
}
