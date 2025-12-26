//
//  JokesService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

enum JokesError: Error {
    case decodingError
    
    var localizedDescription: String {
        "Wrong joke format provided"
    }
}

final class JokesService {
    
    private let networkService: NetworkService = NetworkService()
    
    private var jokeUrl: URL {
        guard let url = URL(string: "https://sv443.net/jokeapi/v2/joke/Any") else {
            preconditionFailure("Unable to construct joke")
        }
        
        return url
    }
    
    func getJoke() async throws -> JokeModel {
        let data = try await networkService.fetch(url: jokeUrl)
        
        if let decodedJoke = try? JSONDecoder().decode(JokeResponse.self, from: data) {
            return decodedJoke.asJokeModel()
        } else if let decodedJoke = try? JSONDecoder().decode(ComplexJokeResponse.self, from: data) {
            return decodedJoke.asJokeModel()
        } else {
            throw JokesError.decodingError
        }
    }
    
    func getJokes(count: Int) async throws -> [JokeModel] {
        var jokes: [JokeModel] = []
        
        for _ in 0..<count {
            let joke = try await getJoke()
            jokes.append(joke)
        }
        
        return jokes
    }
}
