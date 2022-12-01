//
//  Word Model.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/23/22.
//

import Foundation

class Word {
    @Published var currentWord = [LetterModel]() {
        willSet {
            previousWord = currentWord
        }
    }
    var previousWord = [LetterModel]()
    let arrayOfNouns: [String]
    
    func generateNewWord() {
        currentWord.removeAll()
        let randomWordString = arrayOfNouns[Int.random(in: 0..<arrayOfNouns.count)]
        var prevLettersList = [String()]
        for newPosition in 0..<randomWordString.count {
            let currentLetter = randomWordString[newPosition]
            currentWord.append(LetterModel(letter: currentLetter, isRotated: Bool.random(), positions: [newPosition]))
            for pastPosition in 0..<prevLettersList.count {
                let prevLetter = prevLettersList[pastPosition]
                if prevLetter == currentLetter {
                    currentWord[pastPosition - 1].positions.append(newPosition)
                    currentWord[newPosition].positions.append(pastPosition - 1)
                }
            }
            prevLettersList.append(randomWordString[newPosition])
        }
        _ = currentWord.popLast()
    }
    
    func shuffleWord() {
        var wordIsShuffled = false
        while !wordIsShuffled {
            currentWord.shuffle()
            wordIsShuffled = true
            for position in 0..<currentWord.count {
                if currentWord[position].positions.contains(position) { // spicy gibberish
                    wordIsShuffled = false
                }
            }
        }
    }
    
    init() {
        arrayOfNouns = {
            do {
                guard let path = Bundle.main.path(forResource: "dictionary", ofType: "rtf") else {
                    fatalError("could not locate file")
                }
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                return data.components(separatedBy: "\n")
            } catch { fatalError("could not load dictionary") }
        }()
    }
}
