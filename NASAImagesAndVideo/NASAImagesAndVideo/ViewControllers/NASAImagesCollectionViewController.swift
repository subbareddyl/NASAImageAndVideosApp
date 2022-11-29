//
//  NASAImagesAndVideosCollectionViewController.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit

class NASAImagesCollectionViewController: UIViewController {

    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width/2 - 10
        layout.itemSize = CGSizeMake(width, width)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let view = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        return view.withAutolayout()
    }()
    
    private let viewModel = NASAImagesCollectionViewModel()
    private let searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Enter name"
        view.backgroundImage = UIImage()
        return view.withAutolayout()
    }()
    
    private let noResultsView: UILabel = {
        let view = UILabel()
        view.text = "No results"
        return view.withAutolayout()
    }()
    private let activityIndicator:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view.withAutolayout()
    }()

    private let asyncable: Asyncable
    
    init(asyncable: Asyncable = DispatchQueue.main)
    {
        self.asyncable = asyncable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NASA images"
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
        view.addSubview(activityIndicator)
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
        constraints += noResultsView.constraintsToSetToCenterOfSuperView()
        constraints.append(imagesCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10))
        constraints += imagesCollectionView.constraintsToFillSuperViewH()
        constraints.append(imagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(activityIndicator.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(activityIndicator.heightAnchor.constraint(equalToConstant: 100))
        constraints += activityIndicator.constraintsToSetToCenterOfSuperView()
        NSLayoutConstraint.activate(constraints)
    }
    
    private func getImagesAndVideosMetaDataCompletion() -> ((Error?) -> Void)
    {
        return { [weak self] error in
            self?.asyncable.async(group: nil,
                                  qos: .unspecified,
                                  flags: [],
                                  execute: {
                if let imagesData = self?.viewModel.imagesData, imagesData.count > 0 {
                    self?.noResultsView.isHidden = true
                    self?.imagesCollectionView.isHidden = false
                    self?.imagesCollectionView.reloadData()
                } else if let error = error {
                    self?.present(ErrorMessageHelper.getErrorMessageAlertController(error: error),
                                  animated: true)
                }
                self?.activityIndicator.stopAnimating()
            })
        }
    }
}

extension NASAImagesCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            activityIndicator.startAnimating()
            viewModel.getImagesAndVideosMetaData(text: text,
                                                 pageNumber: 1,
                                                 completion: getImagesAndVideosMetaDataCompletion())
        }
        searchBar.resignFirstResponder()
    }
}

extension NASAImagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NASAImagesCell", for: indexPath) as? NASAImagePreviewCell {
            cell.updateViewModel(viewModel: viewModel.imageCellsData[indexPath.item])
            if(indexPath.item == viewModel.imagesData.count - 1) {
                viewModel.getImagesAndVideosMetaDataForNextPage(completion: getImagesAndVideosMetaDataCompletion())
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCellsData.count
    }
}

extension NASAImagesCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewModel = NASAImageDetailViewModel(imageDataModel: viewModel.imagesData[indexPath.item])
        let detailsVC = NASAImageDetailViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
