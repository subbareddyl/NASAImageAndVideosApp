//
//  NASAImagePreviewCell.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/22/22.
//

import UIKit
import Kingfisher

class NASAImagePreviewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    private let stackView: UIStackView = {
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func setupConstraints()
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor))
        constraints.append(imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: -60))
        constraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5))
        constraints.append(stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5))
        constraints.append(stackView.topAnchor.constraint(equalTo: topAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
        NSLayoutConstraint.activate(constraints)
    }

    func updateViewModel(viewModel: NASAImagePreviewCellViewModel)
    {
        imageView.kf.setImage(with: URL(string: viewModel.imageURL),
                              placeholder:UIImage(named: "placeholder-image"))
        nameLabel.text = viewModel.imageName
    }
}
