//
//  JokeModel.swift
//  Jokes
//
//  Created by Ваган Галстян on 21.12.2025.
//

import Foundation

struct JokeModel {
    let description: String
}

extension JokeResponse {
    func asJokeModel() -> JokeModel {
        JokeModel(description: self.joke)
    }
}

extension ComplexJokeResponse {
    func asJokeModel() -> JokeModel {
        let description =
        """
        - \(self.setup)
        
        - \(self.delivery)
        """
        
        return JokeModel(description: description)
    }
}
