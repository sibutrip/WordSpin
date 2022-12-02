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
            return MediumWinChecker()
        case .hard:
            return HardWinChecker()
        }
    }
}

class Game: ObservableObject {
    var winChecker: WinCheckable
    @Published var gameIsWon = false
    @Published var numberOfAttempts = 0
    var wordList: [String]
    @Published var currentWord = Word() {
        willSet { previousWord = currentWord }
        didSet { checkIfMovedLetter() }
    }
    var previousWord = Word()
    
    init(difficulty: Difficulty) {
        winChecker = difficulty.selectDifficulty()
        wordList = WordFileReader().readsWordFile()
        createNewGame()
    }
    
    func checkIfMovedLetter() {
        if previousWord.Letters != currentWord.Letters {
            if winChecker.checkIfWonGame(forWord: currentWord) {
                gameIsWon = true
            }
        }
    }
    
    func generateNewWord(from listOfWords: [String]) -> Word {
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
        var word = String()
        for i in nextWord {
            word += i.letterString
        }
        print(word)
        return Word(Letters: nextWord)
    }
    
    func shuffleLetters(_ word: Word) -> Word {
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
        return Word(Letters: letters)
    }
    
    func createNewGame() {
        let nextWord = generateNewWord(from: wordList)
        if nextWord.Letters.count > 9 {
            createNewGame()
            return
        }
        gameIsWon = false
        currentWord = shuffleLetters(nextWord)
    }
}

