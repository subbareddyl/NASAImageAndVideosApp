//
//  NASAImagePreviewCell.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit
import Kingfisher

class NASAImagePreviewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    var viewModel: NASAImagePreviewCellViewModel?
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        nameLabel.text = nil
    }
    
    private func setupViews()
    {
        addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func setupConstraints()
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5))
        constraints.append(stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5))
        constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func updateViewModel(viewModel: NASAImagePreviewCellViewModel)
    {
        imageView.kf.setImage(with: URL(string: viewModel.imageURL))
        nameLabel.text = viewModel.imageName
    }
}
