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

let host: NWEndpoint.Host = "127.0.0.1"

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

final class UDP {
    init() {
        NWParameters()
        let fn = NWConnection(host: <#T##NWEndpoint.Host#>, port: <#T##NWEndpoint.Port#>, using: <#T##NWParameters#>)
    }
    
    func send() {
        
    }
}

//MARK: SwiftSocket

