//
//  Emittable.swift
//  SwiftyEmitter
//
//  Created by yuta24 on 2017/11/26.
//  Copyright © 2017 yuta24. All rights reserved.
//

import Foundation

public protocol Event: Hashable {}
public protocol Token {}

public protocol Emittable {
    associatedtype E: Event
    associatedtype V
    associatedtype T: Token
    typealias Handler = (V) -> Void
    func on(event: E, handler: @escaping Handler) -> T
    func once(event: E, handler: @escaping Handler) -> T
    func emit(event: E, args: V)
    func remove(event: E, token: T)
    func remove(event: E)
    func removeAll()
}
