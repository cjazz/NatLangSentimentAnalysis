//
//  ContentView.swift
//  NatLangSentimentAnalysis
// 
//  Created by Adam Chin
//
//  This app is a prototype
//  Possible Improvements:
//            I.
//              1. Load your own images encapsulated in a struct or class
//              2. Classify them happy/postivie/worried/neutral
//
//            II.
//              1. Load all the available emojis, load them in your struct or class
//              2. Load an external ML/AI data set
//              3. Create your custom Scoring algoritym to drive what displays based on 2 above
//
//            many other options.... happy coding!


import SwiftUI
import NaturalLanguage

struct ContentView: View {
    
    @State var text: String = ""
    
    var sentiment: String {
        return performSentiment(for: text)
    }
    
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])
    
    var body: some View {
        ScrollView(.vertical){
            VStack {
                Spacer()
                HStack {
                    TextField("Type message...", text: $text)
                        .font(.body)
                        .padding(.all)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text(emoji(for: sentiment))
                        .font(.system(size: 60.0))
                        .frame(maxWidth: .infinity, maxHeight: 60)
                    
                        .transition(.slide)
                        .onTapGesture {
                            updateTextMessage()
                        }
                }
                HStack {
                    Text("Type in: Hello world, I love you \n Or other things.....")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 400, alignment: .bottom)
            .onAppear{
                UITextField.appearance().clearButtonMode = .whileEditing
            }
            .cornerRadius(20)
        }.background(Color.blue)
            .padding()
    }
    
    func performSentiment(for string: String) -> String {
        tagger.string = string
        let (sentiment, _) = tagger.tag(at: string.startIndex,
                                        unit: .paragraph,
                                        scheme: .sentimentScore)
        return sentiment?.rawValue ?? ""
    }
    func updateTextMessage() {
        text = text + " " + emoji(for: sentiment)
    }
    func emoji(for sentiment: String) -> String {
        guard let value = Double(sentiment) else {
            return ""
        }
        if value > 0.5 {
            print("Happy Score")
            return "❤️"
        } else if value >= 0 {
            print("Positive Score")
            return "😍"
        } else if value > -0.5 {
            print("Worried Score")
            return "🥵"
        } else {
            print("Neutral")
            return "😏"
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
