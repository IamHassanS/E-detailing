import UIKit

class CustomHeaderView: UICollectionReusableView {
    // Add any UI elements you want in the header
    
    static  let identifier  = "CustomHeaderView"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appLightTextColor
        label.setFont(font: .medium(size: .BODY))
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        // Add constraints for titleLabel or use auto layout anchors
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
