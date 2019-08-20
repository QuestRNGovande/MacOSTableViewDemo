//
//  UserDataModelView.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/6/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Foundation

enum DisplayMode {
    case plain
    case detail
}

class PurchasesViewModel: NSObject {
    var purchases = [Purchases]()
    private(set) var displayMode: DisplayMode = .plain
    
    override init() {
        super.init()
        loadDummyData()
    }
    
    private func loadDummyData() {
        guard let dummyDataURL = Bundle.main.url(forResource: "MOCK_DATA", withExtension: "json"), let dummyData = try? Data(contentsOf: dummyDataURL) else {
            return
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            purchases = try decoder.decode([Purchases].self, from:  dummyData)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func switchDisplayMode() {
        if displayMode == .plain {
            displayMode = .detail
        }else{
            displayMode = .plain
        }
    }
    
    func getAvatarData(forUserWithID userID: Int?) -> Data? {
        guard let id = userID, let url = Bundle.main.url(forResource: "\(id)", withExtension: "png") else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func getPurchase(withID id: Int?) -> Purchases? {
        return purchases.filter{ $0.id == id }.first
    }
    
    func removePurchase(atIndex index: Int) {
        purchases.remove(at: index)
    }
    
    func sortPurchases(ascending: Bool) {
        purchases.sort { (p1, p2) -> Bool in
            guard let id1 = p1.id, let id2 = p2.id else {return true}
            if ascending {
                return id1 < id2
            }else{
                return id2 < id1
            }
        }
    }
}
