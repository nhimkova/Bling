//
//  MyQredo.swift
//  Bling
//
//  Created by Quynh Tran on 27/02/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import Foundation

class MyQredo: NSObject {
    
    var client       : QredoClient?
    var rendezvous   : QredoRendezvous?
    var conversation : QredoConversation?
    
    struct Constants {
        static let appSecret = "215123b8dd"
        static let userID =  "tutorialuser@test.com"
        static let userSecret = "!%usertutorialPassword"
    }
    
    override init() {
        client = nil
        rendezvous = nil
        conversation = nil
        super.init()
    }
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> MyQredo {
        
        struct Singleton {
            static var sharedInstance = MyQredo()
        }
        
        return Singleton.sharedInstance
    }
    
    
    
    
}