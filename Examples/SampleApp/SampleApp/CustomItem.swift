//
//  TableViewItem.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import TableViewKit

public class CustomDrawer: CellDrawer {
    
    static public var cellType = CellType.class(BaseCell.self)
    
    static public func draw(_ cell: BaseCell, withItem item: Any) {
        let item = item as! CustomItem
        cell.accessoryType = item.accessoryType
        cell.accessoryView = item.accessoryView
        cell.textLabel?.text = item.title.value
    }
}


public class CustomItem: Selectable, Item {

    public var title: NotifyChanges<String>
    public var notifyChanges: Bool = true
    
    public var onSelection: (Selectable) -> () = { _ in }
    
    public var cellStyle: UITableViewCellStyle = .default
    public var accessoryType: UITableViewCellAccessoryType = .none
    public var accessoryView: UIView?
    public var cellHeight: CGFloat? = UITableViewAutomaticDimension
    
    public var drawer: CellDrawer.Type = CustomDrawer.self
    
    public required init(title: String) {
        self.title = NotifyChanges(title)
    }
}
