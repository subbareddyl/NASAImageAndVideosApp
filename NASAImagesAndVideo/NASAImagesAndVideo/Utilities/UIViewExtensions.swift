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
}
