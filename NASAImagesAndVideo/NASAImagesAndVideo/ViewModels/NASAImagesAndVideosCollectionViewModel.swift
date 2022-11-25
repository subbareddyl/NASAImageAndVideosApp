//
//  NASAImagesAndVideosCollectionViewModel.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation
import Alamofire

class NASAImagesAndVideosCollectionViewModel {
    private var nextPageURLString: String?
    private var prevText: String?
    var imagesData = [NASAImagePreviewCellViewModel]()

    func getImagesAndVideosMetaData(text: String,
                                    pageNumber: Int,
                                    completion:@escaping (Error?) -> Void) {
        if prevText != text {
            imagesData = [NASAImagePreviewCellViewModel]()
        }
        AF.request("https://images-api.nasa.gov/search",
                   method: .get,
                   parameters: ["q": text, "page": "\(pageNumber)"])
        .responseDecodable(of: NASAImagesAndVideosSearchResult.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                for item in data.collection.items {
                    if let cellViewModel = self?.getCellViewModelForItem(item: item) {
                        self?.imagesData.append(cellViewModel)
                    }
                }
                for link in data.collection.links {
                    if link.rel == "next" {
                        self?.nextPageURLString = link.href
                    }
                }
                completion(nil)
                break
            case .failure(let error):
                completion(error)
                break
            }
            self?.prevText = text
        }
    }

    func getImagesAndVideosMetaDataForNextPage(completion:@escaping (Error?) -> Void)
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
                                                 imageName: title)
        }
        return nil
    }
}
