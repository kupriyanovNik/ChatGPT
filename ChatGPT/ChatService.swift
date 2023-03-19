//
//  ChatService.swift
//  ChatGPT
//
//  Created by Никита on 03.03.2023.
//

import Foundation
import Alamofire
import Combine

enum Constants {
    static let openAIAPIKey: String = "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"
}

class OpenAIService {
    let baseURL: String = "https://api.openai.com/v1/"
    
    func sendMessage(message: String) -> AnyPublisher<OpenAICompletionsResponse, Error> {
        
        let body: OpenAICompletionsBody = .init(
            model: "text-davinci-003",
            prompt: message,
            temperature: 0.7,
            max_tokens: 256
        )
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.openAIAPIKey)"]
        
        return Future { [weak self] promise in
            guard let self = self else { return }
            AF.request(self.baseURL + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionsResponse.self) { responce in
                
                switch responce.result {
                    case .success(let result):
                        promise(.success(result))
                    case .failure(let error):
                        promise(.failure(error))
                }
                
            }
        }.eraseToAnyPublisher()
        
        
        
    }
    
}

struct OpenAICompletionsBody: Encodable {
    let model: String
    let prompt: String
    let temperature: Float?
    let max_tokens: Int
}

struct OpenAICompletionsResponse: Decodable {
    let id: String
    let choices: [OpenAICompletionsChoice]
}

struct OpenAICompletionsChoice: Decodable {
    let text: String
}
