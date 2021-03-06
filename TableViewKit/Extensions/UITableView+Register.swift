import UIKit

extension UITableView {
    
    /// Register a cell type for reuse
    ///
    /// - parameter type: The type of cell that must be registered
    func register(_ type: CellType) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forCellReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forCellReuseIdentifier: type.reusableIdentifier)
        }
    }

    /// Register a header/footer type for reuse
    ///
    /// - parameter type: The type of header/footer that must be registered
    func register(_ type: HeaderFooterType) {
        switch type {
        case .class(let cellClass):
            self.register(cellClass, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        case .nib(let nib, _):
            self.register(nib, forHeaderFooterViewReuseIdentifier: type.reusableIdentifier)
        }
    }
}
