//
//  GHViewExtension.swift
//  ghmjolnircore
//
//  Created by Javier Carapia on 22/01/22.
//

import UIKit

public extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func constraints(to childView: UIView, constant: CGFloat = 0.0) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant).isActive = true
        childView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -constant).isActive = true
        childView.topAnchor.constraint(equalTo: self.topAnchor, constant: constant).isActive = true
        childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -constant).isActive = true
    }
    
    func constraintsLeft(to childView: UIView, constant: CGFloat = 0.0) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constant).isActive = true
        childView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.0).isActive = true
        childView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.0).isActive = true
    }
    
    func constraintsLeftTop(to childView: UIView, constantLeft: CGFloat = 0.0, constantTop: CGFloat = 0.0) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: constantLeft).isActive = true
        childView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0.0).isActive = true
        childView.topAnchor.constraint(equalTo: self.topAnchor, constant: constantTop).isActive = true
        childView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -0.0).isActive = true
    }
}
