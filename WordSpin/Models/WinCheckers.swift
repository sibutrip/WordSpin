//
//  WinCheckers.swift
//  WordSpin
//
//  Created by Cory Tripathy on 12/1/22.
//

import Foundation

protocol WinCheckable {
    func checkIfWonGame(forWord word: Word) -> Bool
}

struct EasyWinChecker: WinCheckable {
    func checkIfWonGame(forWord word: Word) -> Bool {
        var countCorrectLetters = 0
        for Letter in word.Letters {
            if ["i","l","o","v","w","x"].contains(Letter.letterString) || !Letter.isRotated {
                countCorrectLetters += 1
            }
        }
        if countCorrectLetters == (word.Letters.count) {
            return true
        }
        return false
    }
}

struct MediumWinChecker: WinCheckable {
    func checkIfWonGame(forWord word: Word) -> Bool {
        var areLettersShuffled = [Bool]()
        for position in 0..<word.Letters.count {
            if word.Letters[position].positions.contains(position) { // spicy gibberish: if the position it's in contains the correct position then it's NOT shuffled
                areLettersShuffled.append(false)
            } else {
                areLettersShuffled.append(true)
            }
        }
        if !areLettersShuffled.contains(true) {
            return true
        }
        return false
    }
}


struct HardWinChecker: WinCheckable {
    func checkIfWonGame(forWord word: Word) -> Bool {
        if EasyWinChecker().checkIfWonGame(forWord: word) && MediumWinChecker().checkIfWonGame(forWord: word) {
            return true
        }
        return false
    }
}
