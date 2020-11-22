//
//  LocalizationEN.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/3/20.
//

import Foundation

enum Language: String {
    case En = "En"
    case Ru = "Ru"
}

var currentLanguage: Language = .En

let LocalizationDictionary: [LocalizedUI: [Language: String]] = [
    .newGameTitle: [.En: "New Game",
                    .Ru: "Новая игра"],
    .newGameMessage: [.En: "You have started a new game!",
                      .Ru: "Вы начали новую игру!"],
    
    .winnerTitle: [.En: "You have won!",
                   .Ru: "Вы выиграли!"],
    .winnerMessage: [.En: "had won the game with total score",
                     .Ru: "- вы выиграли игру, набрав"],
    
    .threw1Title: [.En: "You have lost this round",
                   .Ru: "Вы проиграли этот раунд"],
    .threw1Message: [.En: "You threw one, your current score goes to zero",
                     .Ru: "- вы выбросили единицу, очки сгорают"],
   
    .threw6TwiceTitle: [.En: "Busted!", .Ru: "Сгорел!"],
    .threw6TwiceMessage: [.En: "had 6 thrown two times in a row, the total score goes to zero",
                          .Ru: "- выбросил 6 два раза подряд, общие очки теперь ноль"],
    
    .alertActionTitle: [.En: "Okay", .Ru: "Ок"]
]

enum LocalizedUI {
    case newGameMessage
    case newGameTitle

    case winnerTitle
    case winnerMessage
    
    case threw1Title
    case threw1Message
    
    case threw6TwiceTitle
    case threw6TwiceMessage
    
    case alertActionTitle
    
    func translate(to language: Language) -> String {
        return LocalizationDictionary[self]?[language] ?? "Localization error"
    }
}
    
    
    
    


