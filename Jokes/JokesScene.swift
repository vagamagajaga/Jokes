//
//  JokesScene.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import SwiftUI

struct JokesScene: View {
    
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
            viewModel.getJokes()
        }
    }
}

extension JokesScene {
    
    @ViewBuilder
    func jokeView() -> some View {
        if let joke = viewModel.currentJoke {
            Text(joke)
        } else {
            Text("Loading...")
        }
    }
    
    func jokeButton() -> some View {
        Button(
            buttonTitle()
        ) {
            buttonAction()
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
        viewModel.currentJokeIndex == viewModel.jokes.count - 1 ? "Get new jokes" : "Next Joke"
    }
    
    func buttonAction() {
        if viewModel.isLastJoke {
            viewModel.refreshJokes()
        } else {
            viewModel.currentJokeIndex += 1
        }
    }
}

#Preview {
    JokesScene(viewModel: JokesViewModel())
}
