//
//  MYPSocketiable.swift
//  SocketConnet
//
//  Created by 王智刚 on 2018/11/16.
//  Copyright © 2018 王智刚. All rights reserved.
//

import Foundation

public protocol SocketCompatible {
    associatedtype CompatibleType
    var socket: SocketExtension<CompatibleType> { get set }
}

public extension SocketCompatible {
    public var socket: SocketExtension<Self> {
        get { return SocketExtension(self) }
        set { }
    }
}

public class SocketExtension<Base> {
    public let base: Base
    
    init(_ base: Base) {
        self.base = base
    }
}

