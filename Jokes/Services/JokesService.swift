//
//  JokesService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

enum JokesError: Error {
    case decodingError
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
                } else if let decodedJoke = try? JSONDecoder().decode(ComplexJokeResponse.self, from: data) {
                    handler(.success(decodedJoke.asJokeModel()))
                } else {
                    handler(.failure(JokesError.decodingError))
                }
                                    
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
    
    func getJokes(count: Int, handler: @escaping (Result<[JokeModel], Error>) -> Void) {
        var jokes: [JokeModel] = []
        var jokeError: Error? = nil
        let group = DispatchGroup()
        
        for _ in 0..<count {
            group.enter()
            getJoke { result in
                switch result {
                case let .success(joke):
                    jokes.append(joke)
                    group.leave()
                    
                case let .failure(error):
                    jokeError = error
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if let jokeError {
                handler(.failure(jokeError))
            } else {
                handler(.success(jokes))
            }
        }
    }
}
