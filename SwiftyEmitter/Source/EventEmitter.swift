//
//  EventEmitter.swift
//  SwiftyEmitter
//
//  Created by yuta24 on 2017/11/26.
//  Copyright © 2017 yuta24. All rights reserved.
//

import Foundation

public struct HandlerToken: Token, Equatable {
    let id: String

    init() {
        self.id = UUID().uuidString
    }

    public static func ==(lhs: HandlerToken, rhs: HandlerToken) -> Bool {
        return lhs.id == rhs.id
    }
}

public class EventEmitter<EmitterEvent: Event, EmitterValue>: Emittable {
    public typealias E = EmitterEvent
    public typealias V = EmitterValue
    public typealias T = HandlerToken

    public struct EmitterHandler: Equatable {
        let token: HandlerToken
        let raw: Handler

        init(raw: @escaping Handler) {
            self.token = HandlerToken()
            self.raw = raw
        }

        public static func ==(lhs: EmitterHandler, rhs: EmitterHandler) -> Bool {
            return lhs.token == rhs.token
        }
    }

    private var handlers = [E: [EmitterHandler]]()
    private let locker = NSRecursiveLock()

    public init() {
    }

    public func on(event: EmitterEvent, handler: @escaping (EmitterValue) -> Void) -> HandlerToken {
        let handler = EmitterHandler(raw: handler)
        if handlers[event] == nil {
            handlers[event] = []
        }
        handlers[event]?.append(handler)
        return handler.token
    }

    public func once(event: EmitterEvent, handler: @escaping (EmitterValue) -> Void) -> HandlerToken {
        var fired = false
        return on(event: event) { (args) in
            if !fired {
                fired = true
                handler(args)
            }
        }
    }

    public func emit(event: EmitterEvent, args: EmitterValue) {
        locker.lock()
        handlers[event]?.forEach {
            $0.raw(args)
        }
        locker.unlock()
    }

    public func remove(event: EmitterEvent, token: HandlerToken) {
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

    public func remove(event: EmitterEvent) {
        handlers.removeValue(forKey: event)
    }

    public func removeAll() {
        handlers.removeAll()
    }
}
