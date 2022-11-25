//
//  NASAImagesAndVideosSearchResultCollection.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation

struct NASAImagesAndVideosSearchResultCollection: Codable {
    let version: String
    let href: String
    let items: [NASAImagesAndVideosSearchResultItem]
    let links: [Link]
}
