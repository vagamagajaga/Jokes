//
//  JokeViewModel.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation
import Combine

@MainActor
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
    
    func refreshJokes() async {
        if isLastJoke {
            currentJoke = nil
            currentJokeIndex = 0
            await getJokes()
        }
    }
    
    func getJokes() async {
        do {
            jokes = try await jokesService.getJokes(count: 5)
            currentJoke = jokes.first
        } catch {
            self.error = error
        }
    }
}
