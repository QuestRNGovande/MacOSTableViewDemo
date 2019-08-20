//
//  ViewController.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/6/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var selectedAmountLbl: NSTextField!
    @IBOutlet weak var swichDetailDisplayModeBtn: NSButton!
    
    var purchasedViewModel = PurchasesViewModel()
    var originalColumns =  [NSTableColumn]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.originalColumns = tableView.tableColumns
        tableView.doubleAction  = #selector(handleDoubleClick)
        //asdfashdfahfhsk
        setSortDescriptor()
    }
    
    @objc func handleDoubleClick() {
        let clickedRow = tableView.clickedRow
        if purchasedViewModel.displayMode == .plain {
            
            guard clickedRow >= 0, let row = tableView.rowView(atRow: clickedRow, makeIfNecessary: false),
                let cellView = row.view(atColumn:0) as? NSTableCellView, let id = cellView.textField?.integerValue,
                let purchase = purchasedViewModel.getPurchase(withID: id) else{ return }
                showAlert(forPurchase: purchase)
        }else {
            
            guard clickedRow >= 0, let row = tableView.rowView(atRow: clickedRow, makeIfNecessary:  false),
                          let view = row.view(atColumn: 0) as? PurchasesDetailView,
            let purchase = purchasedViewModel.getPurchase(withID: view.idLabel.integerValue) else { return }
            showAlert(forPurchase: purchase)
        }
    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction  func switchDetailDisplayMode(_ sender: Any) {
        purchasedViewModel.switchDisplayMode()
        
        if purchasedViewModel.displayMode == .detail {
            
            for column in tableView.tableColumns.reversed() {
                tableView.removeTableColumn(column)
            }
            
            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "detailsColumn"))
                column.width = tableView.frame.size.width
                column.title = "Purchases Detailed View"
                tableView.addTableColumn(column)
            
            swichDetailDisplayModeBtn?.title = "Switch to Plain Display Mode"
            
        }else {
            tableView.removeTableColumn(tableView.tableColumns[0])
            for column in originalColumns {
                tableView.addTableColumn(column)
            }
            swichDetailDisplayModeBtn?.title = "Switch to Details Display Mode"
        }
        
        tableView.reloadData()
    }

    func showAlert(forPurchase purchase: Purchases) {
        var user = "User"
        var displayAmount = "$0"
        if let username = purchase.userInfo?.username {
            user = username
        }
        
        if let amount = purchase.paymentInfo?.amount {
            displayAmount = amount
        }
        
        let alert = NSAlert()
        alert.messageText = "\(user) spent \(displayAmount) in purchase over the last 24 hours."
        alert.beginSheetModal(for: self.view.window!) { (response) in
            
        }
    }
    
    func setSortDescriptor() {
        let idDescriptor = NSSortDescriptor(key:"id", ascending: true)
        tableView.tableColumns[0].sortDescriptorPrototype = idDescriptor
    }
    
}

extension ViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.purchasedViewModel.purchases.count
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        purchasedViewModel.sortPurchases(ascending: sortDescriptor.ascending)
        tableView.reloadData()
    }
}

extension ViewController  : NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let currentPurchse = purchasedViewModel.purchases[row]
        
        if purchasedViewModel.displayMode == .plain {
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "idColumn") {
                     let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "idCell")
                     guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {
                         return nil
                     }
                     cellView.textField?.integerValue = currentPurchse.id ?? 0
                     return cellView
                 }else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "userInfoColumn") {
                         let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "userinfoCell")
                     guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else {
                         return nil
                     }
                     if let avatarData = purchasedViewModel.getAvatarData(forUserWithID: currentPurchse.userInfo?.id) {
                         cellView.imageView?.image = NSImage(data: avatarData)
                     }
                     cellView.textField?.stringValue = currentPurchse.userInfo?.username ?? ""
                     
                     return cellView
                 }else{
                     let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "paymentinfoCell")
                     
                     guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? PaymentInfoCellView else {
                         return nil
                     }
                     cellView.textField?.stringValue = currentPurchse.paymentInfo?.creditCard ?? ""
                     cellView.creditCardTypeLabel?.stringValue = currentPurchse.paymentInfo?.creditCardType ?? ""
                     cellView.amountLabel?.stringValue = currentPurchse.paymentInfo?.amount ?? ""
                     
                     cellView.purchasesPopup?.removeAllItems()
                     cellView.purchasesPopup?.addItems(withTitles: currentPurchse.paymentInfo?.purchaseTypes ?? [])
                     return cellView
                 }
        }else{
            let view  = PurchasesDetailView()
            view.usernameLabel?.stringValue = currentPurchse.userInfo?.username ?? ""
            
            view.amountLabel?.stringValue = currentPurchse.paymentInfo?.amount ?? ""
            view.creditCardTypeLabel?.stringValue = currentPurchse.paymentInfo?.creditCardType ?? ""
            view.creditCardNumberLabel?.stringValue = currentPurchse.paymentInfo?.creditCard ?? ""
            
            if let avatarData = purchasedViewModel.getAvatarData(forUserWithID: currentPurchse.userInfo?.id) {
                                   view.avatarImageView.image = NSImage(data: avatarData)
            }
            view.idLabel?.integerValue = currentPurchse.userInfo?.id ?? 0
            view.purchesesLabel?.stringValue = currentPurchse.paymentInfo?.purchaseTypes?.joined(separator: ", ") ?? ""
            
            return view
        }
     
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        if purchasedViewModel.displayMode == .plain {
            return 21.0
        }else{
            return 150.0
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        
        if selectedRow >= 0 && tableView.selectedRowIndexes.count == 1 {
            if let amount = purchasedViewModel.purchases[selectedRow].paymentInfo?.amount {
                selectedAmountLbl?.stringValue = "Selected amount: \(amount)"
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, rowActionsForRow row: Int, edge: NSTableView.RowActionEdge) -> [NSTableViewRowAction] {
        
        if edge == .leading {
            let printAction = NSTableViewRowAction(style: .regular, title: "Print") { (action, index) in
                print("Now printing...")
            }
            printAction.backgroundColor = NSColor.gray
            return [printAction]
        }else {
            let deleteAction = NSTableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
                self.purchasedViewModel.removePurchase(atIndex: row)
                self.tableView.reloadData()
            }
            return [deleteAction]
        }
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    
}
