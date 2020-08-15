//
//  GameContext.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/12.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation

/// Context and settings for game.
class CbContext {

    enum EnLanguage: Int {
        case English = 0, Japanese
    }

    var language: EnLanguage = .Japanese

    var highScore = 8150
    var score = 2020
    var credit = 1
    var numberOfPlayers = 3
    var round = 0

}
