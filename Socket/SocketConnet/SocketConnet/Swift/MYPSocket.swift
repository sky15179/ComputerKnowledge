//
//  MYPSocket.swift
//  SocketConnet
//
//  Created by 王智刚 on 2018/11/14.
//  Copyright © 2018 王智刚. All rights reserved.
//

import Foundation

public enum MYPSocketError: Error {
    case noError
    case badParm
    case badConfig
    case connectTimeout
    case closed
    case other
    
    public enum IO {
        case readTimeout
        case readMaxedOut
        case wirteTimeout
    }
}

public enum MYPSocketResult<Value> {
    case success(Value)
    case failure(Error)
    
    public var isSuccess: Bool {
        if case .success(_) = self {
            return true
        } else {
            return false
        }
    }
    
    public var isFailure: Bool {
        return !self.isSuccess
    }
    
    public var value: Value? {
        if case .success(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var error: Error? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}
