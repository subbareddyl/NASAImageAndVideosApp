//
//  NASAImagesAndVideosCollectionViewController.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit

class NASAImagesAndVideosCollectionViewController: UIViewController {

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
        setupViews()
        setupConstraints()
    }

    private func setupViews()
    {
        view.addSubview(searchBar)
        view.addSubview(noResultsView)
    }
    
    private func setupConstraints()
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20))
        constraints.append(searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20))
        constraints.append(searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(noResultsView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(noResultsView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}
