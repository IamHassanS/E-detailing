import Foundation
import Charts
import UIKit


protocol CollapsibleTableViewHeaderDelegate {

    func toggleSection(_ header: UITableViewHeaderFooterView, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0

    let titleLabel = UILabel()
    let arrowLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
    
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.frame = CGRect(x: 250, y: 15, width: 100, height: 20)
        arrowLabel.textColor = UIColor.black
        arrowLabel.font = UIFont(name: "Satoshi-Bold", size: 15)

        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.black
        titleLabel.frame = CGRect(x: 20, y: 15, width: 150, height: 20)
        titleLabel.font = UIFont(name: "Satoshi-Bold", size: 15)

        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowLabel)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
        
    }

    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
