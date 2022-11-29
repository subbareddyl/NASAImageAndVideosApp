//
//  UIViewExtensions.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/28/22.
//

import UIKit

extension UIView {
    func withAutolayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    func constraintsToFillSuperView() -> [NSLayoutConstraint]
    {
        var constraints = [NSLayoutConstraint]()
        guard let superView = superview else {
            return constraints
        }
        constraints.append(leftAnchor.constraint(equalTo: superView.leftAnchor))
        constraints.append(rightAnchor.constraint(equalTo: superView.rightAnchor))
        constraints.append(topAnchor.constraint(equalTo: superView.topAnchor))
        constraints.append(bottomAnchor.constraint(equalTo: superView.bottomAnchor))
        return constraints
    }
    
    func constraintsToFillSuperViewH() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let superView = superview else {
            return constraints
        }
        constraints.append(leftAnchor.constraint(equalTo: superView.leftAnchor))
        constraints.append(rightAnchor.constraint(equalTo: superView.rightAnchor))
        return constraints
    }
    
    func constraintsToFillSuperViewV() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let superView = superview else {
            return constraints
        }
        constraints.append(topAnchor.constraint(equalTo: superView.topAnchor))
        constraints.append(bottomAnchor.constraint(equalTo: superView.bottomAnchor))
        return constraints
    }
    
    func constraintsToSetToCenterOfSuperView() -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        guard let superView = superview else {
            return constraints
        }
        constraints.append(centerXAnchor.constraint(equalTo: superView.centerXAnchor))
        constraints.append(centerYAnchor.constraint(equalTo: superView.centerYAnchor))
        return constraints
    }
}
