//
//  ViewController.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit

class RootViewController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(rootViewController: NASAImagesAndVideosCollectionViewController())
    }
}
