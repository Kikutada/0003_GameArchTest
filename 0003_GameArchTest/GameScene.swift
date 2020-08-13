//
//  GameScene.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/11.
//  Copyright © 2020 Kikutada All rights reserved.
//

import SpriteKit

/// CgCustomBackground creates animation textures by overriden extendTextures function.
class CgCustomBackgroundManager : CgBackgroundManager {

    enum EnBgColor: Int {
        case White = 0
        case Red = 64
        case Purple = 128
        case Cyan = 192
        case Orange = 256
        case Yellow = 320
        case Pink = 384
        case Character = 512
        case Maze = 576
        case Blink = 640
    }

    func print(_ number: Int, color: EnBgColor, column: Int, row: Int, string: String ) {
        let asciiOffset: Int = 16*2  // for offset of ASCII
        putString(number, column: column, row: row, string: string, offset: color.rawValue-asciiOffset)
    }
}


class GameScene: SKScene {
    
    private var sprite: CgSpriteManager!
    private var background: CgCustomBackgroundManager!
    private var sound: CgSoundManager!
    private var context : CbContext!
    
    private var root: CbContainer!
    private var gameScenes: [CgScene] = []

    override func didMove(to view: SKView) {

        root = CbContainer()

        sprite = CgSpriteManager(view: self, imageNamed: "pacman16_16.png", width: 16, height: 16, maxNumber: 64)
        background = CgCustomBackgroundManager(view: self, imageNamed: "pacman8_8.png", width: 8, height: 8, maxNumber: 2)
        sound = CgSoundManager(binding: root, view: self)
        context = CbContext()
        
        gameScenes.append(CgSceneTitle(binding: root, context: context!, deligateSprite: sprite!, deligateBackground: background!, deligateSound: sound!))
        gameScenes.append(CgSceneMaze(binding: root, context: context!, deligateSprite: sprite!, deligateBackground: background!, deligateSound: sound!))
        gameScenes.append(CgSceneIntermission1(binding: root, context: context!, deligateSprite: sprite!, deligateBackground: background!, deligateSound: sound!))
        gameScenes.append(CgSceneIntermission2(binding: root, context: context!, deligateSprite: sprite!, deligateBackground: background!, deligateSound: sound!))
        gameScenes.append(CgSceneIntermission3(binding: root, context: context!, deligateSprite: sprite!, deligateBackground: background!, deligateSound: sound!))

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sound.playSE(.Credit)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    var mode: Int = 4

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered.

        if !gameScenes[mode].enabled {
            mode = mode == 4 ? 0 : mode+1
            gameScenes[mode].resetSequence()
            gameScenes[mode].startSequence()
        }

        root?.sendEvent(message: .Update, parameter: [16])
    }

}
