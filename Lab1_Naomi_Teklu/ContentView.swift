//
//  ContentView.swift
//  Lab1_Naomi_Teklu
//
//  Created by usr on 2025-02-13.
//
import SwiftUI

struct ContentView: View {
    @State private var currentNumber: Int = 0
    @State private var isPrime: Bool = false
    @State private var userAnswer: Bool?
    @State private var correctAnswers: Int = 0
    @State private var wrongAnswers: Int = 0
    @State private var attempts: Int = 0
    @State private var showResults: Bool = false
    @State private var gameStarted: Bool = false
    @State private var timeRemaining = 5
    @State private var timerActive = false
    @State private var didAnswer = false

    let maxRounds = 10

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                if !gameStarted {
                    VStack(spacing: 20) {
                        Text("Prime Number Game")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Decide if the number is Prime or Not Prime before time runs out!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 20)

                        Button(action: startGame) {
                            Text("Start Game")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(width: 200, height: 50)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 15) {
                        Text("Is this a prime number?")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)

                        Text("\(currentNumber)")
                            .font(.system(size: 80, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()

                        Text("Time Remaining: \(timeRemaining) sec")
                            .font(.headline)
                            .foregroundColor(timeRemaining > 2 ? .white : .red)
                            .padding(.bottom, 10)

                        HStack(spacing: 20) {
                            Button(action: { answerSelected(true) }) {
                                Text("Prime")
                                    .font(.title2)
                                    .frame(width: 140, height: 50)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                            .disabled(didAnswer)

                            Button(action: { answerSelected(false) }) {
                                Text("Not Prime")
                                    .font(.title2)
                                    .frame(width: 140, height: 50)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                            .disabled(didAnswer)
                        }
                        .padding(.bottom, 15)

                        ZStack {
                            if didAnswer {
                                Image(systemName: userAnswer == isPrime ? "checkmark.circle.fill" : "x.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(userAnswer == isPrime ? .green : .red)
                                    .transition(.scale)
                                    .animation(.easeInOut, value: userAnswer)
                            } else if timeRemaining == 0 {
                                Image(systemName: "x.circle.fill")
                                    .font(.system(size: 70))
                                    .foregroundColor(.red)
                                    .transition(.scale)
                                    .animation(.easeInOut, value: timeRemaining)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear { resetGame() }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if gameStarted && timerActive {
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else if !didAnswer {
                    answerSelected(nil) // Timer ran out, mark incorrect
                }
            }
        }
        .alert(isPresented: $showResults) {
            Alert(
                title: Text("Game Over"),
                message: Text("Correct: \(correctAnswers)\nWrong: \(wrongAnswers)"),
                dismissButton: .default(Text("Restart")) {
                    resetGame()
                }
            )
        }
    }

    func startGame() {
        gameStarted = true
        timerActive = true
        generateNewNumber()
    }

    func answerSelected(_ answer: Bool?) {
        didAnswer = true
        attempts += 1
        timeRemaining = 5 // Reset timer after each answer

        if let answer = answer {
            userAnswer = answer
            if answer == isPrime {
                correctAnswers += 1
            } else {
                wrongAnswers += 1
            }
        } else {
            // No answer given before time ran out, mark incorrect
            wrongAnswers += 1
        }

        if attempts >= maxRounds {
            showResults = true
            timerActive = false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                generateNewNumber()
            }
        }
    }

    func generateNewNumber() {
        currentNumber = Int.random(in: 1...100)
        isPrime = isNumberPrime(currentNumber)
        userAnswer = nil
        didAnswer = false
    }

    func isNumberPrime(_ number: Int) -> Bool {
        guard number > 1 else { return false }
        for i in 2...Int(sqrt(Double(number))) {
            if number % i == 0 {
                return false
            }
        }
        return true
    }

    func resetGame() {
        gameStarted = false
        correctAnswers = 0
        wrongAnswers = 0
        attempts = 0
        timeRemaining = 5
        timerActive = false
        didAnswer = false
    }
}
  
