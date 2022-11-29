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
    let keywords: [String]?
    let nasaId: String
    let dateCreated: String
    let mediaType: MediaType
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case center = "center"
        case title = "title"
        case keywords = "keywords"
        case nasaId = "nasa_id"
        case dateCreated = "date_created"
        case mediaType = "media_type"
        case description = "description"
    }
}

enum MediaType: String {
    case image = "image",
         video = "video",
         unknown
}

extension MediaType: Codable {
    public init(from decoder: Decoder) throws {
        guard let rawValue = try? decoder.singleValueContainer().decode(String.self) else {
            self = .unknown
            return
        }
        self = MediaType(rawValue: rawValue) ?? .unknown
    }
}
