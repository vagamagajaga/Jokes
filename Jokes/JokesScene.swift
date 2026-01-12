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
    
    func jokeView() -> some View {
        Text(jokeMessage())
    }
    
    func jokeButton() -> some View {
        Button(
            buttonTitle()
        ) {
            buttonAction()
        }
        .padding()
        .background(Color.gray.clipShape(.capsule))
        .foregroundStyle(.white)
        .disabled(viewModel.isLoading)
    }
}

extension JokesScene {
    func buttonTitle() -> String {
        if viewModel.isLoading {
            "Waiting for joke..."
        } else {
            viewModel.isLastJoke ? "Get new jokes" : "Next joke"
        }
    }
    
    func buttonAction() {
        if viewModel.isLastJoke {
            viewModel.refreshJokes()
        } else {
            viewModel.nextJoke()
        }
    }
    
    func jokeMessage() -> String {
        viewModel.currentJoke?.description ?? viewModel.error?.localizedDescription ?? "Loading..."
    }
}

#Preview {
    JokesScene(viewModel: JokesViewModel())
}
