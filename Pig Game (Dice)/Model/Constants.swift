//
//  Constants.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 30.11.20.
//

import UIKit

enum TypeOfGame: String {
    case pigGame1Dice = "pigGame1Dice"
    case pigGame2Dice = "pigGame2Dice"
}

struct Const {
    // Game
    static let DefaultScoreLimit = 100
    static let DelayForCompPlayerMove = 2.0
    
    // Interface
    static let DefaultPlayer1Name = "Player1"
    static let DefaultPlayer2Name = "Player2"
    static let DefaultTypeOfGame: TypeOfGame = .pigGame2Dice
    static let ButtonColor = UIColor(red: 0.603, green: 0.106, blue: 0.112, alpha: 1.0)
    static let DefaultLanguage = Language.En
}