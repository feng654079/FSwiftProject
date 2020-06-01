//
//  Categories.swift
//  ViewTest
//
//  Created by Ifeng科技 on 2020/4/26.
//  Copyright © 2020 Ifeng科技. All rights reserved.
//

import Foundation

//MARK: - Font

enum FontName : String {
    case pingfangsc_regular = "PingFangSC-Regular"
    case pingfangsc_semibold = "PingFangSC-Semibold"
    case pingfangsc_medium = "PingFangSC-Medium"
    case dinalternate_bold = "DINAlternate-Bold"
}

fileprivate let fontScale = UIScreen.main.bounds.size.width / 375.0

let hScale = UIScreen.main.bounds.size.width / 375.0
let vScale = UIScreen.main.bounds.size.height / 667.0



extension UIFont {
    
    static func Font(name: FontName, size:CGFloat) -> UIFont {
        return UIFont.init(name: name.rawValue, size: size * UIScreen.main.bounds.size.width / 375.0) ?? UIFont.systemFont(ofSize: size * UIScreen.main.bounds.size.width / 375.0)
    }
    
}

//MARK:- UIColor
extension UIColor{
    class func hexadecimalColor(hexadecimal:String)->UIColor{
        var cstr = hexadecimal.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString;
        if(cstr.length < 6){
            return UIColor.clear;
        }
        if(cstr.hasPrefix("0X")){
            cstr = cstr.substring(from: 2) as NSString
        }
        if(cstr.hasPrefix("#")){
            cstr = cstr.substring(from: 1) as NSString
        }
        if(cstr.length != 6){
            return UIColor.clear;
        }
        var range = NSRange.init()
        range.location = 0
        range.length = 2
        //r
        let rStr = cstr.substring(with: range);
        //g
        range.location = 2;
        let gStr = cstr.substring(with: range)
        //b
        range.location = 4;
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0;
        var g :UInt32 = 0x0;
        var b :UInt32 = 0x0;
        Scanner.init(string: rStr).scanHexInt32(&r);
        Scanner.init(string: gStr).scanHexInt32(&g);
        Scanner.init(string: bStr).scanHexInt32(&b);
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1);
    }
}


extension UIColor {
    
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

//MARK:- UIView
extension UIView {
    func addSubviews(views:[UIView]) {
        for index in 0..<views.count {
            self.addSubview(views[index])
        }
    }
    
    static func disnableTranslatesAutoresizingMaskIntoConstraints(views:[UIView]) {
        for index in 0..<views.count {
            views[index].translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}

//MARK: - scaled value
protocol ScaledValue{
    
    var hs : CGFloat { get }
}


extension CGFloat: ScaledValue {
    var hs: CGFloat {
        return self * hScale
    }
}

extension Double :ScaledValue {
    var hs: CGFloat {
        return CGFloat(self) * hScale
    }
}


//MARK:-  CALayer animation

extension CALayer {
    
    func drawAnimation(toValue:CGFloat, duration: CGFloat = 1.2) -> CABasicAnimation {
        
        self.isHidden = false
        
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = CFTimeInterval(duration)
        
        return animation
    }
    
    func moveFromCurrentPositionAnimation(to aPostion:CGPoint ,autoreverses:Bool = false, duration: CGFloat = 1.2) -> CABasicAnimation {
        
        debugPrint(self.position)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = self.position
        animation.toValue = aPostion
        animation.duration = CFTimeInterval(duration)
        animation.autoreverses = autoreverses
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        return animation
    }
    
    
}

//MARK:- UILabel
extension UILabel {
    
    func fontFitWidth(minFontScaleFactor: CGFloat = 0.5) {
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = minFontScaleFactor
    }
    
}


//MARK: - UIImage
extension UIImage {
    static func image(with color:UIColor , size:CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                return image
            }
        }
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        return UIImage()
    }
    
}


//MARK:- UICollectionView

extension UICollectionView {
    
    func registerCell(reuseID:AnyClass , nibName:String? = nil) {
        let reuseIDString = NSStringFromClass(reuseID)
        if let nibName = nibName {
            let bundle = Bundle(for: reuseID)
            self.register(UINib(nibName:nibName, bundle: bundle), forCellWithReuseIdentifier: reuseIDString)
        } else {
            self.register(reuseID, forCellWithReuseIdentifier: reuseIDString)
        }
    }
    
}

//MARK:- UICollectionViewCell
extension UICollectionViewCell {
    static var reuseID : String {
        return NSStringFromClass(self)
    }
}


//MARK: - UITableview
extension UITableView {
    func registerCell(reuseID:AnyClass , nibName:String? = nil) {
        let reuseIDString = NSStringFromClass(reuseID)
        if let nibName = nibName {
            let bundle = Bundle(for: reuseID)
            self.register(UINib(nibName:nibName, bundle: bundle), forCellReuseIdentifier: reuseIDString)
        } else {
            self.register(reuseID, forCellReuseIdentifier: reuseIDString)
        }
    }
}

//MARK:-  UITableViewCell
extension UITableViewCell {
    static var reuseID : String {
        return NSStringFromClass(self)
    }
}

//MARK:-  UIViewController
extension UIViewController {
    static func create(fromStoryboardName name: String , identifier:String, bundle:Bundle? = nil) -> UIViewController {
        let sb = UIStoryboard.init(name: name, bundle: bundle)
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        return vc
    }
}


//MARK:- String
extension String {
    //用正则表达式数据对字符串进行匹配,并处理符合正则表达式的情形
    func match(with patterns:[String],matchSuccess handler:(NSTextCheckingResult, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void) {
        guard patterns.count > 0 else {
            return
        }
        for pattern in patterns {
            guard  let regExp = try? NSRegularExpression.init(pattern: pattern, options: .caseInsensitive) else {
                continue
            }
            
            regExp.enumerateMatches(in: self, options: .reportProgress, range: NSRange(location: 0, length: self.count)) { (result, flags, stop) in
                if let result = result {
                    handler(result,flags,stop)
                }
                
            }
            
            
        }
        
    }
}

//MARK:- UIButton
extension UIButton {
    enum ImagePosition {
        case top
        case left
        case right
        case bottom
    }
    
    func setImagePostion(postion:ImagePosition , spaceToTitle:CGFloat = 0.0) {
        
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var titleEdgeInsets = UIEdgeInsets.zero
        
        
        if let imageWidth = self.imageView?.bounds.width,
            let imageHeight = self.imageView?.bounds.height,
            let labelWidth = self.titleLabel?.intrinsicContentSize.width,
            let labelHeight = self.titleLabel?.intrinsicContentSize.height {
            
            switch postion {
            case .top:
                imageEdgeInsets = UIEdgeInsets(top: -labelHeight - spaceToTitle / 2.0, left: 0, bottom: 0, right: -labelWidth)
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - spaceToTitle / 2.0, right: 0)
            case .left:
                imageEdgeInsets = UIEdgeInsets(top:0, left: -spaceToTitle / 2.0, bottom: 0, right:spaceToTitle/2.0)
                titleEdgeInsets = UIEdgeInsets(top:0, left: spaceToTitle / 2.0, bottom: 0, right:-spaceToTitle/2.0)
            case .right:
                imageEdgeInsets = UIEdgeInsets(top:0, left: labelWidth + spaceToTitle / 2.0, bottom: 0, right:-labelWidth - spaceToTitle/2.0)
                titleEdgeInsets = UIEdgeInsets(top:0, left: -imageWidth - spaceToTitle / 2.0, bottom: 0, right:imageWidth + spaceToTitle/2.0)
            case .bottom:
                imageEdgeInsets = UIEdgeInsets(top:0, left: 0, bottom: -labelHeight + spaceToTitle / 2.0 , right: -labelWidth)
                titleEdgeInsets = UIEdgeInsets(top: -imageHeight - spaceToTitle / 2.0, left: -imageWidth, bottom: 0, right: 0)
            }
            
            self.titleEdgeInsets = titleEdgeInsets
            self.imageEdgeInsets = imageEdgeInsets
            
        }
        
        
    }
}

//MARK:- Log

public func spDebugLog(file:String = #file, function:String = #function,line:Int = #line, items:Any...) {
    debugPrint("\(String(describing: file.split(separator: "/").last!)) \(function) \(line):\(items)")
}
