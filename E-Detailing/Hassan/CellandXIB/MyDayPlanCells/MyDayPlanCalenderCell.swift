import FSCalendar

class MyDayPlanCalenderCell: FSCalendarCell {

    // Your custom label
    var planTypeColor: UIColor = .clear
    var customLabel: UILabel!
    var contentHolderView : UIView = {
        let holder = UIView()
        holder.clipsToBounds = true
        holder.backgroundColor = .clear
      //  holder.layer.borderColor = UIColor.gray.cgColor
     //   holder.layer.borderWidth = 0.5
        return holder
    }()
    
    let addedIV: UIView = {
        let image = UIView()
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.layer.cornerRadius = 2.5
        //image.tintColor = .calenderMarkerColor
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
      //  addedIV.layer.cornerRadius =  addedIV.height / 2
        // Initialize and configure your custom label
        customLabel = UILabel()
        customLabel.textAlignment = .center
        addSubview(contentHolderView)
        contentHolderView.addSubview(customLabel)
        contentHolderView.addSubview(addedIV)
        contentHolderView.backgroundColor = .appWhiteColor
        customLabel.textColor = .appLightTextColor
        customLabel.setFont(font: .medium(size: .BODY))
      //  addSubview(customLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Adjust the position of the custom label
        contentHolderView.frame = contentView.bounds
        customLabel.center = contentHolderView.center
        customLabel.frame = CGRect(x: contentHolderView.width / 2 - ((contentHolderView.width / 2) / 2 ), y: contentHolderView.height / 2 - ((contentHolderView.height / 2) / 2), width: contentHolderView.width / 2, height: contentHolderView.height / 2)
       // x: contentHolderView.width / 2
        //y: contentHolderView.bottom - contentHolderView.height / 2
        addedIV.frame = CGRect(x: contentHolderView.width / 2 - 2.5, y: customLabel.bottom, width: 5, height: 5)
       
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset the state of the custom cell
        customLabel.text = nil
        //addedIV.image = nil
       // contentHolderView.backgroundColor = .clear
    }
}
