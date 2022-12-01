//
//  DraggingView.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/28/22.
//

import Foundation
import SwiftUI



struct DraggingView: View {
    enum Gamemode {
        case Rotate, Translate, RotateTranslate
    }
    
    @StateObject private var CurrentGame = Game(difficulty: .medium)
    @StateObject private var devicesDraggingManager = DraggingManager<LetterModel>()
    
    func determineOpacity(_ LetterModel: LetterModel) -> Double {
        guard let letterIndex = CurrentGame.currentWord.Letters.firstIndex(of: LetterModel) else { fatalError("could not locate current word index") }
        if LetterModel.positions.contains(Int(letterIndex)) {
            return 1.0
        }
        return 0.0
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                ForEach(CurrentGame.currentWord.Letters) { LetterModel in
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.mint)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 10).stroke()
                        })
                        .opacity(determineOpacity(LetterModel))
                        .overlay {
                            Text(LetterModel.letterString)
                                .font(.largeTitle)
                        }
                        .draggable(
                            draggingManager: devicesDraggingManager,
                            entry: LetterModel,
                            originalEntries: $CurrentGame.currentWord.Letters
                        )
                }
                .frame(width: geo.size.width / CGFloat(CurrentGame.currentWord.Letters.count), height: geo.size.width / CGFloat(CurrentGame.currentWord.Letters.count))
                .onReceive(CurrentGame.$currentWord) { _ in
                    CurrentGame.checkIfMovedLetter()
                }
            }
            .coordinateSpace(name: devicesDraggingManager.coordinateSpaceID)
            .frame(maxHeight: .infinity)
            .overlay {
                if CurrentGame.gameIsWon {
                    WinView(CurrentGame)
                }
            }
            .overlay(alignment: .top) {
                Text("number of attempts: \(CurrentGame.numberOfAttempts)")
            }
        }
    }
}

struct DraggingView_Previews: PreviewProvider {
    static var previews: some View {
        DraggingView()
    }
}
