//
//  PurchasesDetailView.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/7/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Cocoa

class PurchasesDetailView: NSView, LoadableView {
    var mainView: NSView?
    
    @IBOutlet weak var usernameLabel: NSTextField!
   
    @IBOutlet weak var avatarImageView: NSImageView!
    
    @IBOutlet weak var idLabel: NSTextField!
    
    @IBOutlet weak var creditCardNumberLabel: NSTextField!
    
    @IBOutlet weak var creditCardTypeLabel: NSTextField!
    
    @IBOutlet weak var purchesesLabel: NSTextField!
    
    @IBOutlet weak var amountLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        _ =  load(fromNIBName: "PurchasesDetailView")
    }
    
     required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
 
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

    }
    
}
