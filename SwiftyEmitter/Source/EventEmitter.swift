//
//  EventEmitter.swift
//  SwiftyEmitter
//
//  Created by yuta24 on 2017/11/26.
//  Copyright © 2017 yuta24. All rights reserved.
//

import Foundation

public class EventEmitter<E: Event, V: Any>: Emittable {
    public typealias EventType = E
    public typealias ValueType = V
    public typealias TokenType = HandlerToken

    public struct HandlerToken: Token, Equatable {
        let id: String

        init() {
            self.id = UUID().uuidString
        }

        public static func ==(lhs: HandlerToken, rhs: HandlerToken) -> Bool {
            return lhs.id == rhs.id
        }
    }

    public struct Handler: Equatable {
        let token: HandlerToken
        let raw: HandlerType

        init(raw: @escaping HandlerType) {
            self.token = HandlerToken()
            self.raw = raw
        }

        public static func ==(lhs: Handler, rhs: Handler) -> Bool {
            return lhs.token == rhs.token
        }
    }

    private var handlers = [E: [Handler]]()
    private let locker = NSRecursiveLock()

    public init() {
    }

    public func on(event: E, handler: @escaping ([V]) -> Void) -> HandlerToken {
        let handler = Handler(raw: handler)
        if handlers[event] == nil {
            handlers[event] = []
        }
        handlers[event]?.append(handler)
        return handler.token
    }

    public func emit(event: E, args: [V]) {
        locker.lock()
        handlers[event]?.forEach {
            $0.raw(args)
        }
        locker.unlock()
    }

    public func add(event: E, handler: @escaping ([V]) -> Void) -> HandlerToken {
        let handler = Handler(raw: handler)
        handlers[event]?.append(handler)
        return handler.token
    }

    public func remove(event: E, token: HandlerToken) {
        let indexesOrNil: [Int]? = (handlers[event]?.enumerated().flatMap {
            if $0.element.token == token {
                return nil
            } else {
                return $0.offset
            }
            })

        if let index = indexesOrNil?.first {
            handlers[event]?.remove(at: index)
        }
    }

    public func removeAll() {
        handlers.removeAll()
    }
}
