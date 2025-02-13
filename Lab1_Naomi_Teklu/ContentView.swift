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
    let maxRounds = 10
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
