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

final class JokesService {
    
    private let networkService: NetworkService = NetworkService()
    
    private var jokeUrl: URL {
        guard let url = URL(string: "https://sv443.net/jokeapi/v2/joke/Any") else {
            preconditionFailure("Unable to construct joke")
        }
        
        return url
    }
        
    func getJoke(handler: @escaping (Result<JokeModel, Error>) -> Void) {
        networkService.fetch(url: jokeUrl) { result in
            switch result {
                case .success(let data):
                if let decodedJoke = try? JSONDecoder().decode(JokeResponse.self, from: data) {
                    handler(.success(decodedJoke.asJokeModel()))
                }
                
                if let decodedJoke = try? JSONDecoder().decode(ComplexJokeResponse.self, from: data) {
                    handler(.success(decodedJoke.asJokeModel()))
                }
                                    
            case .failure:
                handler(.failure(JokesError.noJokesAvailable))
            }
        }
    }
    
    func getJokes(count: Int, handler: @escaping (Result<[JokeModel], Error>) -> Void) {
        var jokes: [JokeModel] = []
        let group = DispatchGroup()
        
        for _ in 0..<count {
            group.enter()
            getJoke { result in
                switch result {
                case let .success(joke):
                    jokes.append(joke)
                    group.leave()
                    
                case .failure:
                    handler(.failure(JokesError.noJokesAvailable))
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            handler(.success(jokes))
        }
    }
}
