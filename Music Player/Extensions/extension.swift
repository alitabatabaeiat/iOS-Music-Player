//
//  extension.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func animate(completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.12, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }) { (_) in
            UIView.animate(withDuration: 0.23, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: completion)
        }
    }
    
    func safeAreaTopAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }
    
    func safeAreaBottomAnchor() -> NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    func safeAreaLeftAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }
    
    func safeAreaRightAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }
    
    func safeAreaLeadingAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }
    
    func safeAreaTrailingAnchor() -> NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }
    
    @discardableResult
    func fillSuperview() -> [String:NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor, right: superview?.rightAnchor, bottom: superview?.bottomAnchor, left: superview?.leftAnchor)
    }
    
    @discardableResult
    func anchorSize(to view: UIView) -> [String:NSLayoutConstraint] {
        var constraintList = [String:NSLayoutConstraint]()
        constraintList["width"] = widthAnchor.constraint(equalTo: view.widthAnchor)
        constraintList["width"]!.isActive = true
        constraintList["height"] = heightAnchor.constraint(equalTo: view.heightAnchor)
        constraintList["height"]!.isActive = true
        
        return constraintList
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero, isActive: Bool = true) -> [String:NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraintList = [String:NSLayoutConstraint]()
        if let top = top {
            constraintList["top"] = self.topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let right = right {
            constraintList["right"] = self.rightAnchor.constraint(equalTo: right, constant: -padding.right)
        }
        
        if let bottom = bottom {
            constraintList["bottom"] = self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let left = left {
            constraintList["left"] = self.leftAnchor.constraint(equalTo: left, constant: padding.left)
        }
        
        if size.width != 0 {
            constraintList["width"] = self.widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            constraintList["height"] = self.heightAnchor.constraint(equalToConstant: size.height)
        }
        
        for (_, constraint) in constraintList {
            constraint.isActive = isActive
        }
        
        return constraintList
    }
    
    func aspect(_ width: Int, _ height: Int, widthIsConstrained: Bool) {
        if widthIsConstrained {
            self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        } else {
            self.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        }
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
    
    func makeSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    
    static let turquoiseBlue = UIColor(rgb: 0x64E4FF)
    static let royalBlue = UIColor(rgb: 0x3A7BD5)
    static let ghostWhite = UIColor(rgb: 0xf4f6ff)
    static let grey0 = UIColor(rgb: 0x9B9B9B)
    static let grey1 = UIColor(rgb: 0x424242)
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIFont {
    
    static var raleway: UIFont? { return UIFont(name: "Raleway-v4020-Regular", size: 16) }
    static var ralewayBold: UIFont? { return UIFont(name: "Raleway-v4020-Bold", size: 16) }
    
    static var latoThin: UIFont? { return UIFont(name: "Lato-Thin", size: 16) }
    static var latoLight: UIFont? { return UIFont(name: "Lato-Light", size: 16) }
    static var lato: UIFont? { return UIFont(name: "Lato-Regular", size: 16) }
}

extension UISearchBar {
    
    var cancelButton : UIButton? {
        if let view = self.subviews.first {
            for subView in view.subviews {
                if let cancelButton = subView as? UIButton {
                    return cancelButton
                }
            }
        }
        return nil
    }
}
