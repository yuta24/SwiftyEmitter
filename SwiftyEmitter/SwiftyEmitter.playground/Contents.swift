//: Playground - noun: a place where people can play

import UIKit
import SwiftyEmitter

enum Direction: SwiftyEmitter.Event {
    case up
    case left
    case right
    case down
}

let direction: Direction = .up

print(direction)

let emitter = EventEmitter<Direction, Int>()

let token = emitter.on(event: .up) { (response) in
    print(response)
}

emitter.emit(event: .up, args: [123])
emitter.emit(event: .down, args: [1])

emitter.remove(event: .down, token: token)

emitter.emit(event: .up, args: [456])

emitter.remove(event: .up, token: token)

emitter.emit(event: .up, args: [789])
