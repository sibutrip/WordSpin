//
//  WinView.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/23/22.
//

import Foundation
import SwiftUI

struct WinView: View {
    @ObservedObject var CurrentGame: Game
    var body: some View {
        Text("you\nwin!")
            .font(.largeTitle)
            .bold()
            .foregroundColor(.mint)
            .offset(x: 0, y: -200)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                CurrentGame.createNewGame()
            }
            .background {
                LottieView(animationName: "Fireworks")
                    .offset(x: 0, y: -200)
            }
    }
    init(_ CurrentGame: Game) {
        self.CurrentGame = CurrentGame
    }
}
