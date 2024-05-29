import FSCalendar

class CustomCalendarCell: FSCalendarCell {

    // Your custom label
    var customLabel: UILabel!
    var contentHolderView : UIView = {
        let holder = UIView()
        holder.clipsToBounds = true
        holder.backgroundColor = .clear
      //  holder.layer.borderColor = UIColor.gray.cgColor
     //   holder.layer.borderWidth = 0.5
        return holder
    }()
    
    let addedIV: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "selectIcon")
        image.tintColor = .calenderMarkerColor
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        setupViews()
        
    }

    private func setupViews() {
        // Initialize and configure your custom label
        customLabel = UILabel()
        customLabel.textAlignment = .right
        addSubview(contentHolderView)
        contentHolderView.addSubview(customLabel)
        contentHolderView.addSubview(addedIV)
      //  addSubview(customLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust the position of the custom label
        contentHolderView.frame = contentView.bounds
        customLabel.frame = CGRect(x: contentHolderView.width - contentHolderView.height / 3 - 10, y: 10, width: contentHolderView.height / 3, height: contentHolderView.height / 3)
       // x: contentHolderView.width / 2
        //y: contentHolderView.bottom - contentHolderView.height / 2
        addedIV.frame = CGRect(x: 0, y: contentHolderView.height / 10, width: contentHolderView.width / 2 + contentHolderView.width / 8, height: contentHolderView.height / 2)
       
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the state of the custom cell
        customLabel.text = nil
        //addedIV.image = nil
       // contentHolderView.backgroundColor = .clear
    }
}
