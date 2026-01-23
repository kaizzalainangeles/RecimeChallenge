//
//  User.swift
//  ReciMeChallenge
//
//  Created by Kaizz Alain Benipayo Angeles on 1/22/26.
//

import Foundation

struct User: Codable {
    let id: String
    let userName: String
    let email: String
    let userBio: String
    let followers: Int
    let likes: Int
}
