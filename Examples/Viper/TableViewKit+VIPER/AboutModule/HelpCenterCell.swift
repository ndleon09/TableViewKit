import Foundation
import TableViewKit

class HelpCenterDrawer: CellDrawer {
    
    static var type: CellType = CellType.nib(UINib(nibName: String(describing: HelpCenterCell.self), bundle: Bundle.main), HelpCenterCell.self)
    
    static func draw(_ cell: UITableViewCell, with item: Any) {
        
        guard let helpCenterCell = cell as? HelpCenterCell,
              let helpCenterItem = item as? HelpCenterItem
        else { return }
        
        helpCenterCell.selectionStyle = .none
        helpCenterCell.titleLabel.text = helpCenterItem.title
    }
}

class HelpCenterCell: UITableViewCell, ItemCompatible {
    
    public var item: Item?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var helpCenterButton: UIButton!
    
    @IBAction func helpCenterButtonSelected() {
        guard let helpCenterItem = item as? HelpCenterItem else { return }
        helpCenterItem.onHelpCenterButtonSelected?()
    }
}
