//
//  PaymentInfoCellView.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/7/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Cocoa

class PaymentInfoCellView: NSTableCellView {
    @IBOutlet weak var creditCardTypeLabel: NSTextField?
    @IBOutlet weak var amountLabel: NSTextField?
    @IBOutlet weak var purchasesPopup: NSPopUpButton?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
