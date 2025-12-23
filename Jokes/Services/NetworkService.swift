//
//  NetworkService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

protocol INetwork: Actor {
    func fetch(url: URL) async throws -> Data
}

private enum NetworkError: LocalizedError {
    case responseError(Int)
    case someError
    
    var errorDescription: String? {
        switch self {
        case let .responseError(code):
            return "Error \(code)"
            
        case .someError:
            return "Undefined error"
        }
    }
}

actor NetworkService: INetwork {
    func fetch(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw NetworkError.someError
        }

        return data
    }
}
