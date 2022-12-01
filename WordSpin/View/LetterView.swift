//
//  SpellingView.swift
//  Feeling Buddies
//
//  Created by Brittney Owens  on 11/14/22.
//

import SwiftUI
struct LetterView: View {
    @ObservedObject var CurrentGame: Game
    @Binding var CurrentLetterModel: LetterModel
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.mint)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 10).stroke()
            })
            .overlay {
                
                Text(CurrentLetterModel.letterString)
                    .rotation3DEffect(.degrees(CurrentLetterModel.isRotated ? 180 : 0),axis:(x:0,y:1,z:0))
                    .onTapGesture {
                        CurrentLetterModel.isRotated.toggle()
                        if CurrentGame.checkIfWonGame() {
                            CurrentGame.gameIsWon = true
                        }
                    }
                    .animation(.default, value: CurrentLetterModel.isRotated)
                    .font(.largeTitle)
            }
    }
}
