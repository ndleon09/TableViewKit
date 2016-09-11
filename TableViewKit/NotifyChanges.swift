//
//  NotifyChanges.swift
//  TableViewKit
//
//  Created by Alfredo Delli Bovi on 11/09/2016.
//  Copyright © 2016 odigeo. All rights reserved.
//

import Foundation

internal protocol _NotifyChanges: class {
    var didSet: (() -> ())? { get set }
}

public class NotifyChanges<T>: _NotifyChanges where T:Equatable {
    internal var didSet: (() -> ())?
    
    public var value : T {
        didSet {
            guard value != oldValue else { return }
            didSet?()
        }
    }
    
    public init(_ v : T) {
        value = v
    }
}
