//
//  Asyncable.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/25/22.
//

import Foundation

protocol Asyncable {
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueue: Asyncable{
}
