//
//  JokeViewModel.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation
import Combine

final class JokesViewModel: ObservableObject {
    
    @Published var currentJokeIndex: Int = 0
    @Published var jokes: [JokeModel] = []
    @Published var error: Error?
    
    private let jokesService = JokesService()
    
    init() {}
    
    var currentJoke: String? {
        guard currentJokeIndex <= jokes.count - 1 else { return nil }
            
        return jokes[currentJokeIndex].description
    }
    
    var isLastJoke: Bool {
        currentJokeIndex == jokes.count - 1
    }
    
    func refreshJokes() {
        if isLastJoke {
            jokes = []
            currentJokeIndex = 0
            getJokes()
        }
    }
    
    func getJokes() {
        jokesService.getJokes(count: 5) { result in
            switch result {
            case .success(let jokes):
                    self.jokes = jokes
                
            case .failure(let error):
                    self.error = error
            }
        }
    }
}
