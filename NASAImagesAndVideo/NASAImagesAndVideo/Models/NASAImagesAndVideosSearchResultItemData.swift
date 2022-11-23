//
//  NASAImagesAndVideosSearchResultItemData.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation

struct NASAImagesAndVideosSearchResultItemData: Codable {
    let center: String
    let title: String
    let keywords: [String]
    let nasa_id: String
    let date_created: String
    let media_type: String
    let description: String
}
