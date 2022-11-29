//
//  NASAImagesAndVideosCollectionViewModel.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import Foundation
import Alamofire

class NASAImagesCollectionViewModel {
    private var nextPageURLString: String?
    private var prevText: String?
    private(set) var imageCellsData = [NASAImagePreviewCellViewModel]()
    private(set) var imagesData = [NASAImagesAndVideosSearchResultItem]()
    private let asyncable: Asyncable

    init(asyncable: Asyncable = DispatchQueue.main)
    {
        self.asyncable = asyncable
    }

    func getImagesAndVideosMetaData(text: String,
                                    pageNumber: Int,
                                    completion:@escaping (Error?) -> Void) {
        if prevText != text {
            imageCellsData = [NASAImagePreviewCellViewModel]()
            imagesData = [NASAImagesAndVideosSearchResultItem]()
        }
        AF.request("https://images-api.nasa.gov/search",
                   method: .get,
                   parameters: ["q": text, "page": "\(pageNumber)"])
        .responseDecodable(of: NASAImagesAndVideosSearchResult.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                self?.asyncable.async(group: nil,
                                      qos: .unspecified,
                                      flags: []) {
                    for item in data.collection.items {
                        if let cellViewModel = self?.getCellViewModelForItem(item: item) {
                            self?.imageCellsData.append(cellViewModel)
                            self?.imagesData.append(item)
                        }
                    }
                    self?.nextPageURLString = data.getNextPageURL()
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
        if item.data.first?.mediaType != MediaType.image {
            return nil
        }
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
