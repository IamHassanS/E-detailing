
//
//  ViewUX.swift
//  E-Detailing
//
//  Created by Hassan
//
//  Copyright © 2024 san eforce. All rights reserved. 08/05/24.
//




import Foundation
import UIKit
import MobileCoreServices
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
        self.layer.maskedCorners = [.layerMinXMaxYCorner  , .layerMinXMinYCorner]
    }
    
    
    func setSpecificCornersForRight(cornerRadius : CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMaxXMinYCorner  , .layerMaxXMaxYCorner]
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
    
    
    // Method to create a UIImage from GIF data with a speed multiplier
    public class func gifImageWithData(_ data: Data, speedMultiplier: Double = 1.0) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Image source could not be created")
            return nil
        }

        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }

        let duration = (Double(count) * 0.1) / speedMultiplier
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    // Method to load a GIF from the asset catalog with a speed multiplier
    public class func gif(asset: String, speedMultiplier: Double = 1.0) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gifImageWithData(asset.data, speedMultiplier: speedMultiplier)
        }
        return nil
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
            lblMessage.clipsToBounds = true
            lblMessage.frame=backgroundHolderView.bounds

        }
        lblMessage.tag = 500
        lblMessage.text = strMessage
        lblMessage.textAlignment = NSTextAlignment.center
        lblMessage.numberOfLines = 0
        
        if isFromWishList! {
            lblMessage.textColor = .black
           // lblMessage.backgroundColor = .systemBackground
            lblMessage.font = UIFont(name: "Satoshi-Medium", size: 14)
            backgroundHolderView.layer.cornerRadius = backgroundHolderView.height / 2
            backgroundHolderView.layer.borderColor = UIColor.appTextColor.withAlphaComponent(0.2).cgColor
            backgroundHolderView.layer.borderWidth = 0.5
            backgroundHolderView.layer.backgroundColor = UIColor.appWhiteColor.withAlphaComponent(0.2).cgColor
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
        UIView.animate(withDuration: 3,
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

extension URL {
    
    func getMimeType() -> String {
        _ = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let type = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return type as String
            }
     
        }
        return "application/octet-stream"
    }
    
   
}
//MARK: - Redius & Border & Shadow
extension UIView {
    
    func Border_Radius(border_height: CGFloat, isborder: Bool, radius: CGFloat) {
        
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        
        if isborder {
            
            self.clipsToBounds = true
            self.layer.borderColor = UIColor(rgb: 2632252).cgColor
            self.layer.borderWidth = border_height
        }
    }
    
    func shadow(radius: Double) {
        
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = radius
    }
}


//MARK: - RGB Converter
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


//MARK: - RANDOM COLOR
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red:   .random(),
            green: .random(),
            blue:  .random(),
            alpha: 0.80
        )
    }
}


extension UIImage{
    
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}


//MARK: - Dismiss keybord
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UITextField {
    func setIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 10, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
}

extension String {
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone? = nil) -> Date{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = format
        dateformatter.timeZone = timeZone == nil ?  TimeZone.current : timeZone
        //TimeZone(abbreviation: "UTC") : timeZone
        return dateformatter.date(from: self) ?? Date()
    }
}

extension Date{
    

    func toString(format: String = "hh:mm a",  timeZone: TimeZone? = nil) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone == nil  ? TimeZone.current : timeZone
        //TimeZone(abbreviation: "UTC") : timeZone
        return formatter.string(from: self)
    }
}



class ShadowView: UIView {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.lightGray {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 1) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 0.5 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}


class ShadowButton: UIButton {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }

    /**
    Masks the layer to it's bounds and updates the layer properties and shadow path.
    */
    override func awakeFromNib() {
        super.awakeFromNib()

        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()
    }

    /**
    Updates all layer properties according to the public properties of the `ShadowView`.
    */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
    Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
    */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /**
    Updates the shadow path everytime the views frame changes.
    */
    override func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

