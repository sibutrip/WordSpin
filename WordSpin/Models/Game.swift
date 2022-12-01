//
//  Game.swift
//  Feeling Buddies
//
//  Created by Cory Tripathy on 11/15/22.
//

import Foundation

class Game: Word, ObservableObject {
    var gameIsWon = false
    var numberOfAttempts = 0
    
    func checkIfMovedLetter() {
        if previousWord != currentWord {
            numberOfAttempts += 1
            if checkIfWonGame() {
                winGame()
            }
        }
    }
    
    
    override init() {
        super.init()
        createNewGame()
    }
    
    
    func checkIfWonGame() -> Bool {
        var countCorrectLetters = 0
        for Letter in currentWord {
            if ["i","l","o","v","w","x"].contains(Letter.letter) || !Letter.isRotated {
                countCorrectLetters += 1
            }
        }
        var wordIsShuffled = false
        for position in 0..<currentWord.count {
            if currentWord[position].positions.contains(position) { // spicy gibberish
                wordIsShuffled = false
            } else {
                wordIsShuffled = true
            }
        }
        
        if countCorrectLetters == (currentWord.count) && !wordIsShuffled {
            return true
        }
        return false
    }
    
    func createNewGame() {
        generateNewWord()
        if checkIfWonGame() || currentWord.count > 9 {
            createNewGame()
        }
        shuffleWord()
        gameIsWon = false
    }
    
    func winGame() {
        gameIsWon = true
    }
}
