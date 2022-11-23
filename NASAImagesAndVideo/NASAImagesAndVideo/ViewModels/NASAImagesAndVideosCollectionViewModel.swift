//
//  NASAImagesAndVideosCollectionViewModel.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation
import Alamofire

struct NASAImagesAndVideosCollectionViewModel {
    func getImagesAndVideosMetaData(text: String,
                                    pageNumber: Int) {
        AF.request("https://images-api.nasa.gov/search",
                   method: .get,
                   parameters: ["q": text, "page": "\(pageNumber)"])
        .responseDecodable(of: NASAImagesAndVideosSearchResult.self) { response in
            switch response.result {
            case .success(let data):
                break
            case .failure(let error):
                break
            }
        }
    }
}
