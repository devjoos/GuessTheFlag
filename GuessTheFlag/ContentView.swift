//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Sam Joos on 8/5/22.
//

import SwiftUI

struct WhiteTitle : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func bigTitle() -> some View {
        modifier(WhiteTitle())
    }
}

struct FlagImage: View {
    
    var list: String
    
    var body: some View {
        
        Image(list)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
        
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var turns = 0
    @State private var scoreTitle = ""
    @State private var usersScore = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "The UK", "The US"].shuffled()
    @ State private var correctAnswer = Int.random(in: 0...2)
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700 )
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .bigTitle()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                
                    ForEach(0..<3) {
                        number in
                        Button {
                            flagTapped(number)
                            
                        } label: {
                            FlagImage(list: countries[number])
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(usersScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                if turns <= 7 {
                askQuestion()
                } else {
                    gameOver = true
                }
                
            }
        } message: {
            Text("your score is \(usersScore)")
            
        }
        .alert("Game over, your final score is \(usersScore)", isPresented: $gameOver) {
            Button("Reset Game", action: reset)
        }
}
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            usersScore += 1
        } else {
            scoreTitle = "Wrong, thats the flag of \(countries[number])"
        }

        showingScore = true
        turns += 1
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func reset() {
        askQuestion()
        scoreTitle = ""
        usersScore = 0
        turns = 0
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
