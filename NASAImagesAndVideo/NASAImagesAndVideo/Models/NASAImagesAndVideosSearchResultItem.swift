//
//  NASAImagesAndVideosSearchResultItem.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation

struct NASAImagesAndVideosSearchResultItem: Codable {
    let href: String
    let data: [NASAImagesAndVideosSearchResultItemData]
    let links: [Link]
}
