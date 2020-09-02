//
//  ViewController.swift
//  UDPLearn
//
//  Created by 王智刚 on 2020/8/28.
//  Copyright © 2020 王智刚. All rights reserved.
//

import UIKit
import Network
import SwiftSocket

//游戏联机
//实时视频
//在线聊天

let host: NWEndpoint.Host = "127.0.0.1"
let port: NWEndpoint.Port = 20131

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class Logger {
    class Message: CustomStringConvertible, CustomDebugStringConvertible {
        var description: String {
            return ""
        }
        
        var debugDescription: String {
            return ""
        }
    }
}

class SocketUDP {
    
}

final class UDP {
    private var connection = NWConnection(host: host, port: port, using: .udp)
    
    init() {
    }
    
    func send() {
        let msg = "测试数据"
        let data = msg.data(using: String.Encoding.utf8)
        connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed({ (error) in
            if error == nil {
                print("发送成功")
            } else {
                print("发送失败")
            }
        }))
    }
    
    func listen() {
        let  matrix: [[Int]] = []
        matrix.first?.count
        let s = ""
//        guard s.count > 0 else { return "" }
        let count = s.count
        var resultCount = 0
        for char in s {
            let ele = String(char)
            if ele == " " {
                resultCount += 3
            } else {
                resultCount += 1
            }
        }
        
        var p1 = count
        var p2 = resultCount
        var result = ""
        
        result = s + String(repeating: " ", count: resultCount - count)
        var strs: [String] = []
        for c in s {
            strs.append(String(c))
        }

//        while p1 < p2, p1 >= 0, p2 >= 0 {
//            let curChar = String(s[p1])
//            if curChar != " " {
//                result[p2] = curChar
//                p1 -= 1
//                p2 -= 1
//            } else {
//                result.replaceSubrange([(p2-2)...p2], with: "%20")
//                p1 -= 1
//                p2 -= 3
//            }
//        }
        
//        connection.stateUpdateHandler = { newState in
////            switch newState {
////            case .
////            }
//
//        }
    }
}

//MARK: SwiftSocket

extension String {
    
    subscript(i: Int) -> String {
        guard i >= 0 && i < count else { return "" }
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript(range: Range<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
    }
    
    subscript(range: ClosedRange<Int>) -> String {
        let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) ?? endIndex
        let higherIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) ?? endIndex
        return String(self[lowerIndex..<higherIndex])
    }
}
