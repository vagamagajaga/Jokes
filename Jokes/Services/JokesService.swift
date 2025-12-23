//
//  JokesService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

enum JokesError: Error {
    case noJokesAvailable
    
    var localizedDescription: String {
        "No jokes anymore"
    }
}

actor JokesService {
    
    var responces: [JokeResponse] = []
    
    private let networkService = NetworkService()
    
    private var jokeUrl: URL {
        guard let url = URL(string: "https://sv443.net/jokeapi/v2/joke/Any") else {
            preconditionFailure("Unable to construct joke")
        }
        
        return url
    }
    
    func getJoke() async throws -> JokeModel {
        do {
            let data = try await networkService.fetch(url: jokeUrl)
            if let decodedJoke = try? JSONDecoder().decode(JokeResponse.self, from: data) {
                responces.append(decodedJoke)
                return await decodedJoke.asJokeModel()
            } else if let decodedJoke = try? JSONDecoder().decode(ComplexJokeResponse.self, from: data) {
                return await decodedJoke.asJokeModel()
            } else {
                throw JokesError.noJokesAvailable
            }
        } catch {
            throw error
        }
    }
    
    func getJokes(count: Int) async throws -> [JokeModel] {
        var jokes: [JokeModel] = []
        
        for _ in 0..<count {
            do {
                let joke = try await getJoke()
                jokes.append(joke)
            } catch {
                throw error
            }
        }
        
        return jokes
    }
}
