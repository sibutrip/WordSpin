//
//  Game.swift
//  Feeling Buddies
//
//  Created by Cory Tripathy on 11/15/22.
//

import Foundation

enum Difficulty {
    case easy, medium, hard
    func selectDifficulty() -> WinCheckable {
        switch self {
        case .easy:
            return EasyWinChecker()
        case .medium:
            return MediumWinCheker()
        case .hard:
            return HardWinCheker()
        }
    }
}

class Game: ObservableObject {
    var winChecker: WinCheckable
    @Published var gameIsWon = false
    var numberOfAttempts = 0
    var wordList: [String]
    @Published var currentWord: Word = .init(Letters: [LetterModel]()) { willSet { previousWord = currentWord } }
    var previousWord: Word = .init(Letters: [LetterModel]())
    
    init(difficulty: Difficulty) {
        winChecker = difficulty.selectDifficulty()
        wordList = WordFileReader().readsWordFile()
        createNewGame()
    }
    
    func checkIfMovedLetter() {
        if previousWord.Letters != currentWord.Letters {
            numberOfAttempts += 1
            if checkIfWonGame() {
                gameIsWon = true
            }
        }
    }
    
    func generateNewWord(from listOfWords: [String]) {
        var nextWord = [LetterModel]()
        let randomWordString = listOfWords[Int.random(in: 0..<listOfWords.count)]
        var prevLettersList = [String()]
        for newPosition in 0..<randomWordString.count {
            let currentLetter = randomWordString[newPosition]
            nextWord.append(LetterModel(letterString: currentLetter, isRotated: Bool.random(), positions: [newPosition]))
            for pastPosition in 0..<prevLettersList.count {
                let prevLetter = prevLettersList[pastPosition]
                if prevLetter == currentLetter {
                    nextWord[pastPosition - 1].positions.append(newPosition)
                    nextWord[newPosition].positions.append(pastPosition - 1)
                }
            }
            prevLettersList.append(randomWordString[newPosition])
        }
        _ = nextWord.popLast()
        currentWord = Word(Letters: nextWord)
        var word = String()
        for i in currentWord.Letters {
            word += i.letterString
        }
        print(word)
    }
    
    func shuffleLetters(_ word: Word) {
        var letters = word.Letters
        var wordIsShuffled = false
        while !wordIsShuffled {
            letters.shuffle()
            wordIsShuffled = true
            for position in 0..<letters.count {
                if letters[position].positions.contains(position) { // spicy gibberish
                    wordIsShuffled = false
                }
            }
        }
        currentWord = Word(Letters: letters)
    }
    
    func checkIfWonGame() -> Bool {
        var countCorrectLetters = 0
        for Letter in currentWord.Letters {
            if ["i","l","o","v","w","x"].contains(Letter.letterString) || !Letter.isRotated {
                countCorrectLetters += 1
            }
        }
        var wordIsShuffled = false
        for position in 0..<currentWord.Letters.count {
            if currentWord.Letters[position].positions.contains(position) { // spicy gibberish
                wordIsShuffled = false
            } else {
                wordIsShuffled = true
            }
        }
        
        if countCorrectLetters == (currentWord.Letters.count) && !wordIsShuffled {
            return true
        }
        return false
    }
    
    func createNewGame() {
        generateNewWord(from: wordList)
        if checkIfWonGame() || currentWord.Letters.count > 9 {
            createNewGame()
            return
        }
        shuffleLetters(currentWord)
        gameIsWon = false
    }
}

