//
//  NASAImageDetailViewModel.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/24/22.
//

import Foundation
import Alamofire

struct NASAImageDetailViewModel {
    let imageDataModel: NASAImagesAndVideosSearchResultItem
    
    func getImageData(completion: @escaping (String, Error?) -> Void) {
        AF.request(imageDataModel.href,
                   method: .get)
        .responseDecodable(of: [String].self) {response in
            switch response.result {
            case .success(let data):
                if let imageURL = data.first {
                    completion(imageURL, nil)
                } else {
                    completion("", InvalidDataError.InvalidData)
                }
                break
            case .failure(let error):
                completion("", error)
                break
            }
        }
    }
}

enum InvalidDataError: Error {
    case InvalidData
}
