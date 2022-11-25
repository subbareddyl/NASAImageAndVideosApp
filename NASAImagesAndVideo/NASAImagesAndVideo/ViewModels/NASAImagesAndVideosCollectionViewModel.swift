//
//  NASAImagesAndVideosCollectionViewModel.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation
import Alamofire

class NASAImagesAndVideosCollectionViewModel {
    var nextPageURLString: String?
    
    func getImagesAndVideosMetaData(text: String,
                                    pageNumber: Int,
                                    completion:@escaping ([NASAImagePreviewCellViewModel], Error?) -> Void) {
        AF.request("https://images-api.nasa.gov/search",
                   method: .get,
                   parameters: ["q": text, "page": "\(pageNumber)"])
        .responseDecodable(of: NASAImagesAndVideosSearchResult.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                let items = data.collection.items
                var cellViewModels = [NASAImagePreviewCellViewModel]()
                for item in items {
                    if let cellViewModel = self?.getCellViewModelForItem(item: item) {
                        cellViewModels.append(cellViewModel)
                    }
                }
                for link in data.collection.links {
                    if link.rel == "next" {
                        self?.nextPageURLString = link.href
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

    func getImagesAndVideosMetaDataForNextPage(completion:@escaping ([NASAImagePreviewCellViewModel], Error?) -> Void)
    {
        var queryItemsMap = [String: String]()
        if let nextPageURLString = nextPageURLString {
            let urlComponents = URLComponents(string: nextPageURLString)
            let queryItems = urlComponents?.queryItems ?? [URLQueryItem]()
            for item in queryItems {
                queryItemsMap[item.name] = item.value
            }
        }
        getImagesAndVideosMetaData(text: queryItemsMap["q"] ?? "",
                                   pageNumber: Int(queryItemsMap["page"] ?? "1") ?? 1,
                                   completion: completion)
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
            return NASAImagePreviewCellViewModel(imageURL: imageURL,
                                                 imageName: title,
                                                 imagesCollectionURL:item.href)
        }
        return nil
    }
}
