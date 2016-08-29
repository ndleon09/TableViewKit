//
//  TableViewManager.swift
//  TableViewKit
//
//  Created by Nelson Dominguez Leon on 07/06/16.
//  Copyright © 2016 ODIGEO. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit

public class TableViewManager: NSObject {
    
    // MARK: Properties
    public let tableView: UITableView
    public var sections: CollectionProperty<[Section]> = CollectionProperty([])
    
    public var validator: ValidatorManager<String?> = ValidatorManager()
    public var errors: [ValidationError] {
        get {
            return validator.errors
        }
    }
    
    let disposeBag = DisposeBag()


    // MARK: Inits
    
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        sections.observeNext { e in
            guard e.inserts.count + e.updates.count + e.deletes.count > 0 else { return }

            e.inserts.forEach { index in
                e.collection[index].register(tableViewManager: self)
            }
            
            tableView.beginUpdates()
            if e.inserts.count > 0 {
                tableView.insertSections(NSIndexSet(e.inserts), withRowAnimation: .Automatic)
            }
            
            if e.updates.count > 0 {
                tableView.reloadSections(NSIndexSet(e.updates), withRowAnimation: .Automatic)
            }
            
            if e.deletes.count > 0 {
                tableView.deleteSections(NSIndexSet(e.deletes), withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
        }.disposeIn(disposeBag)
    }
    
    public convenience init(tableView: UITableView, sections: [Section]) {
        self.init(tableView: tableView)
        self.sections.insertContentsOf(sections, at: 0)
    }
    
}

extension TableViewManager {
    
    private func itemForIndexPath(indexPath: NSIndexPath) -> ItemProtocol {
        return sections[indexPath.section].items[indexPath.row]
    }
}

extension TableViewManager: UITableViewDataSource {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        return section.items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = itemForIndexPath(indexPath)
        let drawer = item.drawer
        
        let cell = drawer.cell(inManager: self, withItem: item, forIndexPath: indexPath)
        drawer.draw(cell: cell, withItem: item)
        
        return cell
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = itemForIndexPath(indexPath)
        return item.cellHeight ?? tableView.estimatedRowHeight
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let item = itemForIndexPath(indexPath)
        return item.cellHeight ?? tableView.rowHeight
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let section = sections[section]
        
        if let headerView = section.headerView {
            return CGRectGetHeight(headerView.frame)
        }
        
        return CGFloat(Constants.Frame.HeaderViewHeight)
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection sectionIndex: Int) -> String? {
        return sections[sectionIndex].footerTitle
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection sectionIndex: Int) -> UIView? {
        return sections[sectionIndex].footerView
    }
}

extension TableViewManager: UITableViewDelegate {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let item = itemForIndexPath(indexPath) as? ItemSelectable else { return }
        item.onSelection(item)
    }
    
}










