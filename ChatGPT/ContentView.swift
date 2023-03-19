//
//  ContentView.swift
//  ChatGPT
//
//  Created by Никита on 03.03.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var chatMessages: [ChatMessage] = []
    @State private var messageText: String = ""
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) { message in
                        messageView(message)
                    }
                }
            }
            HStack {
                TextField("Enter a message to GPT", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                Button {
                    sendMessage()
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                }

            }
        }
        .padding()
        .onAppear {
            
        }
    }
    @ViewBuilder func messageView(_ message: ChatMessage) -> some View {
        HStack {
            if message.sender == .me { Spacer() }
            Text(message.content)
                .foregroundColor(message.sender == .me ? .white : .black)
                .padding()
                .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                .cornerRadius(16)
            if message.sender == .gpt { Spacer() }
        }
    }
    func sendMessage() {
        let myMessage: ChatMessage = .init(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        withAnimation {
            chatMessages.append(myMessage)
        }
        OpenAIService().sendMessage(message: messageText).sink { completion in
            // handle error
        } receiveValue: { response in
            guard let firstItem = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else { return }
            let gptMessage: ChatMessage = .init(id: response.id, content: firstItem, dateCreated: Date(), sender: .gpt)
            withAnimation {
                chatMessages.append(gptMessage)
            }
        }.store(in: &cancellables)

        messageText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
