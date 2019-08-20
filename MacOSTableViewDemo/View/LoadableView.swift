//
//  LoadableView.swift
//  MacOSTableViewDemo
//
//  Created by Ratnadeep Govande on 8/7/19.
//  Copyright © 2019 Ratnadeep Govande. All rights reserved.
//

import Foundation
import Cocoa

protocol LoadableView: class {
    var mainView: NSView? { get set }
    func load(fromNIBName nibName: String) -> Bool
}

extension LoadableView where Self: NSView {
    func load(fromNIBName nibName: String) -> Bool {
        var nibObjects: NSArray?
        let nibName = NSNib.Name(stringLiteral: nibName)
        
        if Bundle.main.loadNibNamed(nibName, owner: self, topLevelObjects: &nibObjects) {
            guard let nibObjects = nibObjects else { return false }
            
            let viewObjects = nibObjects.filter { $0 is NSView }
            if viewObjects.count > 0 {
                guard let view = viewObjects[0] as? NSView else {
                    return false
                }
                mainView = view
                
                self.addSubview(mainView!)
                mainView?.translatesAutoresizingMaskIntoConstraints = false
                mainView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                mainView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                mainView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                mainView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                
                return true
            }
            
        }
        return false
    }
}
