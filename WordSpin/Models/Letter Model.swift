//
//  Letter Model.swift
//  WordSpin
//
//  Created by Cory Tripathy on 11/23/22.
//

import Foundation

struct LetterModel: Identifiable, Equatable {
    let id = UUID()
    let letterString: String
    var isRotated: Bool
    var positions: [Int]
}
