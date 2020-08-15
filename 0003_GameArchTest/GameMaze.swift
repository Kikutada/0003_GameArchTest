//
//  GameMaze.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/13.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation

/// Maze scene class for play mode
/// This class has some methods to draw a maze and starting messages.
class CgSceneMaze : CgSceneFrame {

    private let mazeSource: [String] = [
            "aggggggggggggjiggggggggggggb",
            "e111111111111EF111111111111f",
            "e1AGGB1AGGGB1EF1AGGGB1AGGB1f",
            "e3E  F1E   F1EF1E   F1E  F3f",
            "e1CHHD1CHHHD1CD1CHHHD1CHHD1f",
            "e11111111111111111111111111f",
            "e1AGGB1AB1AGGGGGGB1AB1AGGB1f",
            "e1CHHD1EF1CHHJIHHD1EF1CHHD1f",
            "e111111EF1111EF1111EF111111f",
            "chhhhB1EKGGB1EF1AGGLF1Ahhhhd",
            "     e1EIHHD2CD2CHHJF1f     ",
            "     e1EF          EF1f     ",
            "     e1EF QhUWWVhR EF1f     ",
            "gggggD1CD f      e CD1Cggggg",
            "__    1   f      e   1    __" ,
            "hhhhhB1AB f      e AB1Ahhhhh",
            "     e1EF SggggggT EF1f     ",
            "     e1EF          EF1f     ",
            "     e1EF AGGGGGGB EF1f     ",
            "aggggD1CD1CHHJIHHD1CD1Cggggb",
            "e111111111111EF111111111111f",
            "e1AGGB1AGGGB1EF1AGGGB1AGGB1f",
            "e1CHJF1CHHHD2CD2CHHHD1EIHD1f",
            "e311EF1111111  1111111EF113f",
            "kGB1EF1AB1AGGGGGGB1AB1EF1AGl",
            "YHD1CD1EF1CHHJIHHD1EF1CD1CHZ",
            "e111111EF1111EF1111EF111111f",
            "e1AGGGGLKGGB1EF1AGGLKGGGGB1f",
            "e1CHHHHHHHHD1CD1CHHHHHHHHD1f",
            "e11111111111111111111111111f",
            "chhhhhhhhhhhhhhhhhhhhhhhhhhd"
    ]

        
    private var blinkingTimer: Int = 0
    
    /// Handle sequence
    /// To override in a derived class.
    /// - Parameter sequence: Sequence number
    /// - Returns: If true, continue the sequence, if not, end the sequence.
    override func handleSequence(sequence: Int) -> Bool {
        switch sequence {
            case  0:
                drawMaze()
                printFrame()
                printPlayerScore()
                printHighScore()
                printPlayers()
                printRounds()
                printStateMessage(.GameOver)
                goToNextSequence(after: 4000)

            case  1:
                blinkingTimer = 104  // 104*16ms = 1664ms
                goToNextSequence()

            case  2:
                if blinkingTimer == 0 {
                    goToNextSequence()
                } else {
                    let remain = blinkingTimer % 26
                    if remain == 0 {
                        drawFrame(color: .White)
                    } else if remain == 13 { // 13*16ms = 208ms
                        drawFrame(color: .Blue)
                    }
                    blinkingTimer -= 1
                }

            case 3:
                return false

            default:
                return false
        }
        return true
    }

    
    enum EnPrintStateMessage {
        case PlayerOneReady, Ready, ClearPlayerOne, ClearReady, GameOver
    }
    
    /// Print starting message
    /// - Parameter state: Kind of message
    func printStateMessage(_ state: EnPrintStateMessage) {
        switch state {
            case .PlayerOneReady:
                deligateBackground.print(0, color: .Cyan, column:  9, row: 21, string: "PLAYER ONE")
                fallthrough
            case .Ready:
                deligateBackground.print(0, color: .Yellow, column: 11, row: 15, string: "READY!")
            case .ClearPlayerOne:
                deligateBackground.print(0, color: .Cyan, column:  9, row: 21, string: "          ")
            case .ClearReady:
                deligateBackground.print(0, color: .Yellow, column: 11, row: 15, string: "      ")
            case .GameOver:
                deligateBackground.print(0, color: .Red, column:  9, row: 15, string: "GAME  OVER")
        }
    }
    
    ///　Draw maze with walls and dots 
    private func drawMaze() {
        var row = BG_HEIGHT-4

        for str in mazeSource {
            var i = 0
            for c in str.utf8 {
                var txNo: Int
                switch c {
                    case 50 : txNo = 592  // Oneway with dot "2" -> "1"
                    case 95 : txNo = 576  // Slow "_" -> " "
                    default : txNo = Int(c)+544 // 576-32
                }
                deligateBackground.put(0, column: i, row: row, texture: txNo)
                i += 1
            }
            row -= 1
        }
    }
    
    enum EnMazeColor: Int {
        case Blue = 0, White = 1
    }
    
    /// Draw only the wall of the maze
    /// - Parameter color: Maze color
    private func drawFrame(color: EnMazeColor) {
        var row = BG_HEIGHT-4
        let offset: Int = color.rawValue*48

        for str in mazeSource {
            var i = 0
            for c in str.utf8 {
                var txNo: Int
                if c < 57 || c == 87 {
                    txNo = offset+576
                } else {
                    txNo = Int(c)+offset+544
                }
                deligateBackground.put(0, column: i, row: row, texture: txNo)
                i += 1
            }
            row -= 1
        }
    }
    
}


