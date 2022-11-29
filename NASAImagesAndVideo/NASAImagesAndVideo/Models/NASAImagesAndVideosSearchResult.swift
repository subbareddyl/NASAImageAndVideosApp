//
//  NASAImagesAndVideosSearchResult.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation

struct NASAImagesAndVideosSearchResult: Codable {
    let collection:NASAImagesAndVideosSearchResultCollection
}

extension NASAImagesAndVideosSearchResult {
    func getNextPageURL() -> String? {
        for link in collection.links {
            if link.rel == "next" {
                return link.href
            }
        }
        return nil
    }
}
