//
//  BasedComponents.swift
//  0003_GameArchTest
//
//  Created by Kikutada on 2020/08/12.
//  Copyright © 2020 Kikutada. All rights reserved.
//

import Foundation

/// Based object class
class CbObject {

    // Kind of Message ID to handled events in object.
    enum EnMessage: Int {
        case None
        case Update
        case Timer
        case Touch
        case Swipe
        case Accel
    }
    
    // When it is true, object can handle events.
    var enabled: Bool = true

    // For accessing parent objects.
    private var parent: CbObject?
    
    /// Initialize self without parent object.
    init() {
        parent = nil
    }
    
    /// Initialize self with parent object.
    /// - Parameter object: Parent object.
    init(binding object: CbObject) {
        parent = object
        parent?.bind(self)
    }
    
    /// Bind self to a specified object.
    /// - Parameter object: Object to bind self.
    func bind( _ object: CbObject) {
        // TO DO: override
        // (This is pure virtual method.)
    }

    // Send event messages.
    /// - Parameters:
    ///   - id: Message ID
    ///   - values: Parameters of message.
    func sendEvent(message id: EnMessage, parameter values: [Int]) {
        recieveEvent(sender: self, message: id, parameter: values)
    }
    
    /// Handler called by sendEvent method to receive events.
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    func recieveEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        guard enabled else { return }
        handleEvent(sender: sender, message: message, parameter: values)
        if message == .Update {
            update(interval: values[0])
        }
    }
    
    /// Event handler
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    func handleEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        // TO DO: override
        // (This is pure virtual method.)
    }

    /// Update handler
    /// - Parameter interval: Interval time(ms) to update.
    func update(interval: Int) {
        // TO DO: override
        // (This is pure virtual method.)
    }

}

/// Container class that bind objects.
class CbContainer : CbObject {
    
    private var objects: [CbObject] = []

    /// Bind self to a specified object.
    /// - Parameter object: Object to bind self.
    override func bind( _ object: CbObject) {
        objects.append(object)
    }
    
    /// Handler called by sendEvent method to receive events.
    /// It sends messages to all contained object.
    /// - Parameters:
    ///   - sender: Message sender
    ///   - id: Message ID
    ///   - values: Parameters of message
    override func recieveEvent(sender: CbObject, message: EnMessage, parameter values: [Int]) {
        guard enabled else { return }

        super.recieveEvent(sender: sender, message: message, parameter: values)

        for t in objects {
            t.recieveEvent(sender: self, message: message, parameter: values)
        }
    }
}

/// Countdown timer class
///
///  Usages:
///    var timer: CbTimer!
///    timer = CbTimer(binding: self)
///    timer.set(time: 1600) //ms
///    timer.start()  // start counting
///    .. counting ..
///    if timer.isFired() { /* action */ }
///    timer.restart()
///
class CbTimer : CbObject {

    private var currentTime = 0
    private var settingTime = 0
    private var eventFired = false

    func reset() {
        currentTime = settingTime
        eventFired = false
        self.enabled = false
    }
    
    func set(interval: Int) {
        settingTime = interval
        reset()
    }

    func start() {
        self.enabled = true
    }

    func restart() {
        reset()
        start()
    }

    func pause() {
        self.enabled = false
    }

    func stop() {
        self.enabled = false
        currentTime = 0
    }

    func get() -> Int {
        return currentTime
    }
    
    func isCounting() -> Bool {
        return self.enabled && currentTime > 0
    }
    
    func isEventFired() -> Bool {
        return eventFired
    }
    
    /// Update handler
    /// - Parameter interval: Interval time(ms) to update.
    override func update(interval: Int) {
        guard isCounting() else { return }

        currentTime -= interval
        if currentTime <= 0 {
            currentTime = 0
            eventFired = true
        }
    }

}

