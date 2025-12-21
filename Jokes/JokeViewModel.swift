//
//  JokeViewModel.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation
import Combine

final class JokesViewModel: ObservableObject {
    
    @Published var currentJoke: JokeModel?
    @Published var error: Error?
    
    private var jokes: [JokeModel] = []
    private var currentJokeIndex: Int = 0

    private let jokesService = JokesService()
    
    init() {}
    
    var isLastJoke: Bool {
        currentJokeIndex == jokes.count - 1
    }
    
    func nextJoke() {
        guard !isLastJoke else { return }
        currentJokeIndex += 1
        currentJoke = jokes[currentJokeIndex]
    }
    
    func refreshJokes() {
        if isLastJoke {
            currentJoke = nil
            currentJokeIndex = 0
            getJokes()
        }
    }
    
    func getJokes() {
        jokesService.getJokes(count: 5) { result in
            switch result {
            case .success(let jokes):
                self.jokes = jokes
                self.currentJoke = jokes.first
                
            case .failure(let error):
                self.error = error
            }
        }
    }
}
