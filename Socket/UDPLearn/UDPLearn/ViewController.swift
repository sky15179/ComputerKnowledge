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
        connection.stateUpdateHandler = { newState in
//            switch newState {
//            case .
//            }
            
        }
    }
}

//MARK: SwiftSocket

