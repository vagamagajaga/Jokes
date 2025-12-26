//
//  JokesScene.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import SwiftUI

struct JokesScene: View {
    
    @MainActor
    @ObservedObject var viewModel: JokesViewModel
    
    var body: some View {
        VStack {
            jokeView()
            
            Spacer()
            
            jokeButton()
        }
        .padding(.top, 140)
        .padding(.bottom, 60)
        .padding(.horizontal, 24)
        .onAppear {
            Task {
                await viewModel.setJokes()
            }
        }
    }
}

extension JokesScene {
    
    func jokeView() -> some View {
        Text(jokeMessage())
    }
    
    func jokeButton() -> some View {
        Button(
            buttonTitle()
        ) {
            Task {
                await buttonAction()
            }
        }
        .padding()
        .background(
            Color.gray
                .clipShape(.capsule)
            
        )
        .foregroundStyle(.white)
    }
}

extension JokesScene {
    func buttonTitle() -> String {
        viewModel.isLastJoke ? "Get new jokes" : "Next Joke"
    }
    
    func buttonAction() async {
        if viewModel.isLastJoke {
            await viewModel.refreshJokes()
        } else {
            viewModel.nextJoke()
        }
    }
    
    func jokeMessage() -> String {
        if let joke = viewModel.currentJoke {
            joke.description
        } else if let error = viewModel.error {
            error.localizedDescription
        } else {
            "Loading..."
        }
    }
}

#Preview {
    JokesScene(viewModel: JokesViewModel())
}
