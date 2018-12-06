//
//  extension.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

extension UIView {
    
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
        constraintList["width"]!.isActive = true
        
        return  constraintList
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero, isActive: Bool = true) -> [String:NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraintList = [String:NSLayoutConstraint]()
        if let top = top {
            constraintList["top"] = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let right = right {
            constraintList["right"] = rightAnchor.constraint(equalTo: right, constant: -padding.right)
        }
        
        if let bottom = bottom {
            constraintList["bottom"] = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let left = left {
            constraintList["left"] = leftAnchor.constraint(equalTo: left, constant: padding.left)
        }
        
        if size.width != 0 {
            constraintList["width"] = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            constraintList["height"] = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        for (_, constraint) in constraintList {
            constraint.isActive = isActive
        }
        
        return constraintList
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
}
