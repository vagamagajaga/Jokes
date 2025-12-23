//
//  JokeResponses.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

nonisolated struct JokeResponse: Decodable {
    let error: Bool
    let category, type, joke: String
    let id: Int
    let safe: Bool
    let lang: String
    let flags: Flags
}

nonisolated struct ComplexJokeResponse: Decodable {
    let error: Bool
    let category, type, setup, delivery: String
    let id: Int
    let safe: Bool
    let lang: String
    let flags: Flags
}

struct Flags: Decodable {
    let nsfw, religious, political, racist: Bool
    let sexist, explicit: Bool
}
