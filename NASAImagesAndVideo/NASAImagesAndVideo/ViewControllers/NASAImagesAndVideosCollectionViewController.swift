//
//  NASAImagesAndVideosCollectionViewController.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit

class NASAImagesAndVideosCollectionViewController: UIViewController {

    let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width/2 - 10
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel = NASAImagesAndVideosCollectionViewModel()
    let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Enter name"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundImage = UIImage()
        return view
    }()
    
    let noResultsView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "No results"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NASA images and videos"
        view.backgroundColor = UIColor.white
        searchBar.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.register(NASAImagePreviewCell.self, forCellWithReuseIdentifier: "NASAImagesCell")
        imagesCollectionView.isHidden = true
        setupViews()
        setupConstraints()
    }

    private func setupViews()
    {
        view.addSubview(searchBar)
        view.addSubview(noResultsView)
        view.addSubview(imagesCollectionView)
    }
    
    private func setupConstraints()
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5))
        constraints.append(searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5))
        constraints.append(searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        constraints.append(imagesCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10))
        constraints.append(imagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor))
        constraints.append(imagesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor))
        constraints.append(imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getImagesAndVideosMetaDataCompletion() -> ((Error?) -> Void)
    {
        return { [weak self] error in
            if let imagesData = self?.viewModel.imagesData, imagesData.count > 0 {
                self?.noResultsView.isHidden = true
                self?.imagesCollectionView.isHidden = false
                self?.imagesCollectionView.reloadData()
            }
            if let error = error {
                let alertController = UIAlertController(title: "Error",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true)
            }
        }
    }
}

extension NASAImagesAndVideosCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            viewModel.getImagesAndVideosMetaData(text: text,
                                                 pageNumber: 1,
                                                 completion: getImagesAndVideosMetaDataCompletion())
        }
        searchBar.resignFirstResponder()
    }
}

extension NASAImagesAndVideosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NASAImagesCell", for: indexPath) as? NASAImagePreviewCell {
            cell.updateViewModel(viewModel: viewModel.imagesData[indexPath.item])
            if(indexPath.item == viewModel.imagesData.count - 1) {
                viewModel.getImagesAndVideosMetaDataForNextPage(completion: getImagesAndVideosMetaDataCompletion())
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imagesData.count
    }
}

extension NASAImagesAndVideosCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
