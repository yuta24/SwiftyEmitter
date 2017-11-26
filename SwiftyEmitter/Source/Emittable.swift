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
    typealias HandlerType = ([EventType]) -> Void
    func on(eventName: String, handler: @escaping HandlerType)
    func emit(eventName: String, args: [EventType])
    func add(eventName: String, handler: @escaping HandlerType)
    func remove(eventName: String, handler: @escaping HandlerType)
    func removeAll(eventName: [String])
}
