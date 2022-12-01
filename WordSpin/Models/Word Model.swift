//
//  Word Model.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/23/22.
//

import Foundation


struct WordFileReader {
    func readsWordFile() -> [String] {
        do {
            guard let path = Bundle.main.path(forResource: "dictionary", ofType: "rtf") else {
                fatalError("could not locate file")
            }
            let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return data.components(separatedBy: "\n")
        } catch { fatalError("could not load dictionary") }
    }
}

struct Word {
    var Letters: [LetterModel]
}
