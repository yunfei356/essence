//
//  Message.swift
//  zhiyouios
//
//  Created by Yun Fei Guo on 2018-12-05.
//  Copyright © 2018 Yun Fei Guo. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct Message {
    let member: Member
    let text: String
    let messageId: String
}

extension Message: MessageType {
    
    var sender: Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

struct Member {
    var name: String!
    var color: UIColor!
}
