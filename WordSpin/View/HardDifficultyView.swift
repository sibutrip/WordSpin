//
//  HardDifficultyView.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/28/22.
//

import SwiftUI
import UniformTypeIdentifiers


struct HardDifficultyView: View {
    @StateObject var CurrentGame = Game()
    var xOffset: CGFloat {
        if CurrentGame.currentWord.count == 2 {
            return CGFloat(49)
        } else if CurrentGame.currentWord.count == 3 {
            return CGFloat(39)
        } else if CurrentGame.currentWord.count == 4 {
            return CGFloat(33)
        } else if CurrentGame.currentWord.count == 5 {
            return CGFloat(27)
        } else if CurrentGame.currentWord.count == 6 {
            return CGFloat(25)
        } else if CurrentGame.currentWord.count == 7 {
            return CGFloat(22)
        } else if CurrentGame.currentWord.count == 8 {
            return CGFloat(19)
        } else if CurrentGame.currentWord.count == 9 {
            return CGFloat(17)
        } else {
            return CGFloat(0)
        }
    }
    var body: some View {
        GeometryReader { geo in
            HStack {
                ForEach(CurrentGame.currentWord) { LetterModel  in
                    HardView(CurrentGame: CurrentGame, Letter: LetterModel, location: CGPoint(x: xOffset, y: geo.size.height / 2))
                        .frame(width: geo.size.width / CGFloat(CurrentGame.currentWord.count + 2), height: geo.size.width / CGFloat(CurrentGame.currentWord.count + 2))
                    
                }
            }

        }
    }
}

struct HardDifficultyView_Previews: PreviewProvider {
    static var previews: some View {
        HardDifficultyView()
    }
}

