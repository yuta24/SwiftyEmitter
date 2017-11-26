//
//  Emittable.swift
//  SwiftyEmitter
//
//  Created by yuta24 on 2017/11/26.
//  Copyright © 2017 yuta24. All rights reserved.
//

import Foundation

public protocol Event: Hashable {}

public protocol Emittable {
    associatedtype EventType: Event
    associatedtype ValueType: Any
    typealias HandlerType = ([ValueType]) -> Void
    func on(event: EventType, handler: @escaping HandlerType)
    func emit(event: EventType, args: [ValueType])
    func add(event: EventType, handler: @escaping HandlerType)
    func remove(event: EventType, handler: @escaping HandlerType)
    func removeAll()
}
