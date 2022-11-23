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
                                    pageNumber: Int,
                                    completion:@escaping ([NASAImagePreviewCellViewModel], Error?) -> Void) {
        AF.request("https://images-api.nasa.gov/search",
                   method: .get,
                   parameters: ["q": text, "page": "\(pageNumber)"])
        .responseDecodable(of: NASAImagesAndVideosSearchResult.self) { response in
            switch response.result {
            case .success(let data):
                let items = data.collection.items
                var cellViewModels = [NASAImagePreviewCellViewModel]()
                for item in items {
                    if let cellViewModel = getCellViewModelForItem(item: item) {
                        cellViewModels.append(cellViewModel)
                    }
                }
                completion(cellViewModels, nil)
                break
            case .failure(let error):
                completion([NASAImagePreviewCellViewModel](), error)
                break
            }
        }
    }

    private func getCellViewModelForItem(item: NASAImagesAndVideosSearchResultItem) -> NASAImagePreviewCellViewModel? {
        var title = ""
        if item.data.count > 0 {
            title = item.data[0].title
        }
        var imageURL: String?
        if let links = item.links {
            for link in links {
                if link.rel == "preview" {
                    imageURL = link.href
                }
            }
        }
        if let imageURL = imageURL {
            return NASAImagePreviewCellViewModel(imageURL: imageURL, imageName: title)
        }
        return nil
    }
}
