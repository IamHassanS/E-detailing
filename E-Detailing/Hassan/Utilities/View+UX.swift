
//
//  ViewUX.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/10/23.
//




import Foundation
import UIKit
//import SDWebImage

private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10

extension UIView {



    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }


    public enum closureActions : Int{
        case none = 0
        case tap = 1
        case swipe_left = 2
        case swipe_right = 3
        case swipe_down = 4
        case swipe_up = 5
    }

    public struct closure {
        typealias emptyCallback = ()->()
        static var actionDict = [Int:[closureActions : emptyCallback]]()
        static var btnActionDict = [Int:[String: emptyCallback]]()
    }

    public func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }

    public func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {

        if type == .none{
            return
        }
        //        print("∑type : ",type)
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }

    @objc public func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    @objc public func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    @objc public func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    @objc public func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    @objc public func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }

    public
    func addAction(for type: closureActions ,
                   Action action:@escaping() -> Void) {
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self,
                              action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            gesture.addTarget(self,
                              action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            gesture.addTarget(self,
                              action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.up
            gesture.addTarget(self,
                              action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.down
            gesture.addTarget(self,
                              action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
    }
}



extension UIView {
    public var width: CGFloat {
        return frame.size.width
    }
    public var height: CGFloat {
        return frame.size.height
    }
    public var top: CGFloat {
        return frame.origin.y
    }
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    public var left: CGFloat {
        return frame.origin.x
    }
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}


extension UIView {
//
//    var cornerRadius : CGFloat {
//        get { return layer.cornerRadius }
//        set { layer.cornerRadius = newValue }
//    }
//
//    /// Note : - Variable used For Set Border Width Alone in all Views
//    var borderWidth : CGFloat {
//        get { return layer.borderWidth }
//        set {
//            layer.borderWidth = newValue
//            self.layer.shouldRasterize = true
//            self.layer.rasterizationScale = UIScreen.main.scale
//        }
//    }
//
//    /// Note : - Variable used For Set Border Color Alone in all Views
//    var borderColor : UIColor? {
//        get { return UIColor(cgColor: self.layer.shadowColor!) }
//        set {
//            layer.borderColor = newValue?.cgColor
//            self.layer.shouldRasterize = true
//            self.layer.rasterizationScale = UIScreen.main.scale
//        }
//    }
//
    
  
    
    func elevate(_ elevation: Double,
                 shadowColor : UIColor = .lightGray,
                 opacity : Float = 0.3) {
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: elevation)
        self.layer.shadowRadius = abs(elevation > 0 ? CGFloat(elevation) : -CGFloat(elevation))
        self.layer.shadowOpacity = opacity
    }

    func setSpecificCornersForTop(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively

    }


    //layerMinXMinYCorner    top left corner
    //layerMaxXMinYCorner    top right corner
    //layerMinXMaxYCorner    bottom left corner
    //layerMaxXMaxYCorner    bottom right corner

    func setSpecificCornersForLeft(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    func setSpecificCornersForBottom(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    func setSpecificCorners()
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] // Top right corner, Top left corner respectively
    }
    func removeSpecificCorner(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 0
        self.layer.maskedCorners = [] //
    }
}

extension UIView {
    func addTapIntraction(Intraction: Bool,Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = Intraction
        self.addGestureRecognizer(gesture)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
}

extension UIView {
    func togetCurrentMonthNoDate() -> (Int, Date) {
        let currentDate = Date()
        let calendar = Calendar.current
        let currentMonthNumber = calendar.component(.month, from: currentDate)
        var sampleCurrentMonthDate = Date()
        if let sampleDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: currentMonthNumber, day: 1)) {
            print("Sample Date for the Current Month: \(sampleDate)")
            sampleCurrentMonthDate = sampleDate
        } else {
            print("Error creating sample date.")
        }
        
        return (currentMonthNumber, sampleCurrentMonthDate)
    }
    
    
    func toGetcurrentNextPrevMonthNumbers() -> [Int] {
        let currentDate = Date()

        // Get the calendar
        let calendar = Calendar.current

        // Get the current month number
        let currentMonthNumber = calendar.component(.month, from: currentDate)

        // Calculate the previous month number
        let previousMonthNumber = (currentMonthNumber - 2 + 12) % 12 + 1

        // Calculate the next month number
        let nextMonthNumber = (currentMonthNumber % 12) + 1

        // Create an array with current, previous, and next month numbers
        let monthNumbers = [previousMonthNumber, currentMonthNumber, nextMonthNumber]
        
      //  let formattedMonthNumbers = monthNumbers.map { String(format: "%02d", $0) }

        print("Month Numbers: \(monthNumbers)")
        return monthNumbers
    }
    
}


extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewController.modalPresentationStyle = .overCurrentContext
        } else {
            // Fallback on earlier versions
        }

        //    viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: animated, completion: completion)
    }
}
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImage {
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }

    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gifImageWithData(imageData)
    }

    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }

            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
        }()

        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)]).withRenderingMode(.alwaysTemplate)
            frameCount = Int(delays[Int(i)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame.withRenderingMode(.alwaysTemplate))
            }
        }

        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 3750)

        return animation
    }

    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)

        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        delay = delayObject as! Double

        if delay < 0.1 {
            delay = 0.1
        }

        return delay
    }

    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }

        if a == b {
            let c = a
            a = b
            b = c
        }

        var rest: Int
        while true {
            rest = a! % b!

            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }




}

extension UIImageView {
//    func setImageWithHeaders(_ url: String) {
//        let imageUrl = URL(string: url)!
//
//        // Create custom headers as a dictionary
//
//
//        // Set the custom headers for the image request
//        SDWebImageDownloader.shared.setValue(LocalStorage.shared.getString(key: .accessToken), forHTTPHeaderField: "Authorization")
//        SDWebImageDownloader.shared.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        // Use SDWebImage to load the image with the custom headers
//        self.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "noImageThumb"))
//    }
}

extension UIImageView {
    private var loaderTag: Int { return 987654 } // Unique tag for the loader view
    
    func showLoadingIndicator() {
        let loaderView = UIActivityIndicatorView(style: .medium)
        loaderView.tintColor = .appLightPink
        loaderView.tag = loaderTag
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loaderView)
        
        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        loaderView.startAnimating()
    }
    
    func hideLoadingIndicator() {
        // Find and remove the loader subview using the tag
        self.subviews.first(where: { $0.tag == loaderTag })?.removeFromSuperview()
    }
}

extension UIView{
    func shake(_ completion : @escaping ()->()){
        let translationY : CGFloat = self.frame.width * 0.065
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.calculationModeLinear], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2, animations: {
                self.transform =  CGAffineTransform(translationX: 0, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: -translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransform(translationX: -translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.1, animations: {
                self.transform = CGAffineTransform(translationX: translationY, y: 0)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.transform =  .identity
            })
        }) { (completed) in
            if completed{
                completion()
            }
        }
    }
}
extension UIView{
    func freeze(for time : DispatchTime = .now() + 2){
        guard self.isUserInteractionEnabled else{return}
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: time) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }

    func setGradient() {
      //  var gradientView = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors =
        [UIColor.white.cgColor,UIColor.black.withAlphaComponent(0.5).cgColor]
       //Use diffrent colors
        self.layer.addSublayer(gradientLayer)
    }
}




extension UIView {

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension ReusableView where Self : UIView {
     static func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
    static func getViewFromXib<T: ReusableView>() -> T?{
        return self.nib().instantiate(withOwner: nil, options: nil).first as? T
    }

    func setupFromNib<T: ReusableView & UIView>(_ object : T) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            guard let view : T = Self.getViewFromXib(),
                !object.subviews.compactMap({$0.tag}).contains(2523143) else { fatalError("Error loading \(self) from nib") }
            view.tag = 2523143
            view.frame = object.bounds
            view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            object.addSubview(view)
            object.bringSubviewToFront(view)
      }

    }
}

extension String {
    var containsSpecialCharacter: Bool {
        let regex = "^(?=.*[a-z])(?=."
        + "*[A-Z])(?=.*\\d)"
        + "(?=.*[-+_!@#$%^&*., ?]).+$"
        let testString = NSPredicate(format:"SELF MATCHES %@", regex)
        return testString.evaluate(with: self)
    }


    var isValidMail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: self)
    }

    func isValiduserName(Input:String) -> Bool {
        let RegEx = "\\w{1,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
    }
    
    func toConVertStringToDate() -> Date {
       // let dateString = yyyyMMdd
        
        // Create a DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert the string to a Date object
        if let date = dateFormatter.date(from: self) {
            print(date)
            return date
        } else {
            print("Error: Unable to convert the string to a Date.")
            return Date()
        }
    }

}

@available(iOS 13.0, *)
extension AppDelegate {
    
    func createToastMessage(_ strMessage:String,
                            bgColor: UIColor = .white,
                            textColor: UIColor = .white, isFromSearch: Bool? = false, isFromWishList: Bool? = false) {
        var keyWindow = UIWindow()

        guard let keyedWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive || $0.activationState == .background || $0.activationState == .foregroundInactive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
       
        else { return }
        
        keyWindow = keyedWindow
    

        var lblMessage = UILabel()
        var backgroundHolderView=UIView()
        backgroundHolderView.isUserInteractionEnabled = false
        if !isFromSearch! && !isFromWishList! {
            lblMessage=UILabel(frame: CGRect(x: 0,
                                                y: keyWindow.frame.height + 70,
                                                width: keyWindow.frame.size.width,
                                                height: 70))
        } else if isFromSearch!{
            
            
            
            lblMessage=UILabel(frame: CGRect(x: 0,
                                                y: keyWindow.frame.size.height -  keyWindow.frame.size.height / 20,
                                                width: keyWindow.frame.size.width,
                                             height: keyWindow.frame.size.height / 20))
        } else if isFromWishList! {
            backgroundHolderView=UIView(frame: CGRect(x: keyWindow.width / 1.2 -  keyWindow.width / 1.2 / 1.1, y: keyWindow.bottom - keyWindow.height / 15 , width: keyWindow.width / 1.2, height: keyWindow.height / 20))
//            UIView(frame: CGRect(x: (keyWindow.width / 1.2) / 2 - (keyWindow.width / 1.2) / 2.5,
//                                                      y: keyWindow.frame.size.height -  keyWindow.frame.size.height / 15 - (keyWindow.frame.size.height/20),
//                                                      width: keyWindow.frame.size.width/1.2,
//                                                   height: keyWindow.frame.size.height / 15))
            lblMessage.clipsToBounds = true
            lblMessage.frame=backgroundHolderView.bounds
//                UILabel(frame: CGRect(x: backgroundHolderView.left + 5,
//                                                 y: backgroundHolderView.top + 5,
//                                                 width: backgroundHolderView.width - 10,
//                                                 height: backgroundHolderView.height - 10))
        }
        lblMessage.tag = 500
        lblMessage.text = strMessage
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
      //  moveLabelToYposition(lblMessage)
//        if !isFromSearch! && !isFromWishList! {
//            lblMessage.textColor = .white
//            lblMessage.backgroundColor = .cyan
//            lblMessage.font = UIFont.systemFont(ofSize: 15, weight: .medium)
//            lblMessage.layer.shadowColor = UIColor.darkGray.cgColor
//            moveLabelToYposition(lblMessage,
//                                 win: keyWindow)
//            keyWindow.addSubview(lblMessage)
//
//        } else if isFromSearch!{
//            lblMessage.textColor = .black
//            lblMessage.backgroundColor = .white
//            lblMessage.font = UIFont.systemFont(ofSize: 14, weight: .light)
//            lblMessage.layer.shadowColor = UIColor.darkGray.cgColor
//            moveSearchLabelToYposition(lblMessage,
//                                       win: keyWindow)
//            keyWindow.addSubview(lblMessage)
//        } else
        if isFromWishList! {
            lblMessage.textColor = .black
           // lblMessage.backgroundColor = .systemBackground
            lblMessage.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            backgroundHolderView.layer.cornerRadius = backgroundHolderView.height / 2
            backgroundHolderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            backgroundHolderView.layer.borderWidth = 0.5
            backgroundHolderView.layer.backgroundColor = UIColor.white.withAlphaComponent(0.8).cgColor
           // backgroundHolderView.layer.cornerRadius =  backgroundHolderView.height / 6
           // backgroundHolderView.elevate(2, radius:  backgroundHolderView.height / 4)
            keyWindow.addSubview(backgroundHolderView)
            backgroundHolderView.addSubview(lblMessage)
            moveWishlistToastToYposition(backgroundHolderView,
                                       win: keyWindow)
            
        }
    }
    
    func moveWishlistToastToYposition(_ holderView:UIView,
                              win: UIWindow) {
        UIView.animate(withDuration: 2,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            holderView.frame = CGRect(x: win.width / 1.2 - win.width / 1.2 / 1.1,
                                      y: win.bottom + win.height / 15,
                                      width: win.width / 1.2,
                                   height: win.height / 15)
            
            
        }, completion: { (finished: Bool) -> Void in
            self.onWishListCloseAnimation(holderView,
                                   win: win)
        })
    }
    
    func onWishListCloseAnimation(_ holderView:UIView,
                          win: UIWindow) {
        UIView.animate(withDuration: 2,
                       delay: 3.5,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
            holderView.frame = CGRect(x: win.width / 1.2  - win.width / 1.2 / 1.1,
                                            y: win.bottom + win.height / 15,
                                            width: win.width / 1.2,
                                         height: win.height / 15)
        }, completion: { (finished: Bool) -> Void in
            holderView.removeFromSuperview()
        })
    }
}


extension UILabel {
    func setFont(font customFont: CustomFont) {
      
        self.font = customFont.instance
    }
}

extension UIView {
   
        
    

    func addExternalBorder(borderWidth: CGFloat = 2.0, borderColor: UIColor = .black) -> CALayer {
        let externalBorder = CALayer()
        externalBorder.frame = CGRect(x: -borderWidth, y: -borderWidth, width: frame.size.width + 2 * borderWidth, height: frame.size.height + 2 * borderWidth)
        externalBorder.borderColor = borderColor.cgColor
        externalBorder.borderWidth = borderWidth
        externalBorder.name = Themes.externalBorderName

        layer.insertSublayer(externalBorder, at: 0)
        layer.masksToBounds = false

        return externalBorder
    }

    func removeExternalBorders() {
        layer.sublayers?.filter() { $0.name == Themes.externalBorderName }.forEach() {
            $0.removeFromSuperlayer()
        }
    }

    func removeExternalBorder(externalBorder: CALayer) {
        guard externalBorder.name == Themes.externalBorderName else { return }
        externalBorder.removeFromSuperlayer()
    }
}


/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}


extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gifImageWithData(asset.data)
        }
        return nil
    }
}


extension UISegmentedControl {
    func font(name:String?, size:CGFloat?) {
        let attributedSegmentFont = NSDictionary(object: UIFont(name: name!, size: size!)!, forKey: NSAttributedString.Key.font as NSCopying)
        setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: .normal)
    }
}

//

//extension UIView {
//    
//    
//    func toAddBlurtoVIew() {
//        
//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterialDark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        blurEffectView.alpha = 0.5
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.addSubview(blurEffectView)
//        
//    }
//    
//    func toremoveBlurFromView() {
//        for subview in self.subviews {
//            if subview is UIVisualEffect {
//                subview.removeFromSuperview()
//            }
//        }
//    }
//    
//}
