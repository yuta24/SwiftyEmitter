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

let token = emitter.on(event: .up) { (args) in
    print("up: \(args)")
}

emitter.emit(event: .up, args: [123])
emitter.emit(event: .down, args: [1])

emitter.remove(event: .down, token: token)

emitter.emit(event: .up, args: [456])


emitter.remove(event: .up, token: token)

emitter.emit(event: .up, args: [789])

emitter.once(event: .left) { (args) in
    print("left: \(args)")
}

emitter.emit(event: .left, args: [123])
emitter.emit(event: .left, args: [456])
emitter.emit(event: .left, args: [789])

emitter.on(event: .right) { (args) in
    print("right: \(args)")
}
emitter.on(event: .right) { (args) in
    print("right: \(args)")
}
emitter.remove(event: .right)
emitter.emit(event: .right, args: [123])
