//
//  NetworkService.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

protocol INetwork {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
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
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.responseError(response.statusCode)))
                return
            }
            
            guard let data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
