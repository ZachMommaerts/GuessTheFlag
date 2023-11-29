//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Zach Mommaerts on 8/20/23.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            //.renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

extension View {
    func editFlag() -> some View {
        modifier(FlagImage())
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var turn = 1
    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var buttonTapped = 0
    @State private var scaleSize = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700 )
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            buttonTapped = number
                            withAnimation {
                                flagTapped(number)
                            }
                        } label: {
                            Image(countries[number])
                                .editFlag()
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                        .rotation3DEffect(.degrees(number == buttonTapped ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0))
                        .opacity(buttonTapped != number ? opacityAmount : 1.0)
                        .scaleEffect(buttonTapped != number ?scaleSize : 1.0)
                        .animation(.default, value: buttonTapped)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert(scoreTitle, isPresented: $showingFinalScore) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(score)/\(turn)")
        }
    }
    
    func flagTapped(_ number: Int) {
        
        opacityAmount = 0.25
        animationAmount += 360
        scaleSize = 0.5
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! You chose the flag of \(countries[number])"
            if score > 0 {
                score -= 1
            }
        }
        
        if turn == 3 {
            showingFinalScore = true
            return
        }
        
        turn += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1.0
        scaleSize = 1.0
    }
    
    func restartGame() {
        turn = 1
        score = 0
        askQuestion()
        opacityAmount = 1.0
        scaleSize = 1.0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
