//
//  ContentView.swift
//  Feeling Buddies
//
//  Created by Brittney Owens  on 11/14/22.
//

import SwiftUI


struct EasyDifficultyView: View {
    @StateObject var CurrentGame = Game(difficulty: .easy)
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach($CurrentGame.currentWord.Letters) { LetterModel in
                    LetterView(
                        CurrentGame: CurrentGame,
                        CurrentLetterModel: LetterModel)
                }.frame(width: geo.size.width / CGFloat(CurrentGame.currentWord.Letters.count), height: geo.size.width / CGFloat(CurrentGame.currentWord.Letters.count))
            }
            .frame(maxHeight: .infinity)
            .overlay {
                if CurrentGame.gameIsWon {
                    WinView(CurrentGame)
                }
            }
        }
    }
}

struct EasyDifficultyView_Previews: PreviewProvider {
    static var previews: some View {
        EasyDifficultyView()
    }
}
