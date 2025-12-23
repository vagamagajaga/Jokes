//
//  NetworkService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

protocol INetwork {
    func fetch(url: URL) async throws -> Data
}

private enum NetworkError: LocalizedError {
    case responseError(Int)
    
    var errorDescription: String? {
        switch self {
        case let .responseError(code):
            return "Error \(code)"
        }
    }
}

struct NetworkService: INetwork {
    func fetch(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let response = response as? HTTPURLResponse,
           !(200..<300).contains(response.statusCode) {
            throw NetworkError.responseError(response.statusCode)
        }
        
        return data
    }
}
