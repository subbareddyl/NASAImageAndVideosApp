//
//  NASAImageDetailViewController.swift
//  NASAImagesAndVideo
//
//  Created by Subbareddy l on 11/24/22.
//

import UIKit
import Kingfisher

class NASAImageDetailViewController: UIViewController {
    private let scrollView = UIScrollView().withAutolayout()
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 10
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        return view.withAutolayout()
    }()
    private let viewModel: NASAImageDetailViewModel
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view.withAutolayout()
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.numberOfLines = 0
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label.withAutolayout()
    }()
    private let dateLabel = UILabel()
    private let activityIndicator:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return view.withAutolayout()
    }()
    
    init(viewModel: NASAImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        addSubviews()
        titleLabel.text = viewModel.imageDataModel.data.first?.title
        if let date = viewModel.imageDataModel.data.first?.dateCreated {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let date = dateFormatter.date(from: date) {
                dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.long)
            }
        }
        descriptionLabel.text = viewModel.imageDataModel.data.first?.description
        activityIndicator.startAnimating()
        viewModel.getImageData(completion: { [weak self] imageURLString, error in
            if let error = error {
                self?.present(ErrorMessageHelper.getErrorMessageAlertController(error: error),
                              animated: true)
            } else {
                self?.imageView.kf.setImage(with: URL(string: imageURLString), completionHandler: { result in
                    switch result {
                    case .success(let imageResult):
                        let size = imageResult.image.size
                        let ratio = size.width/size.height
                        if let imageView = self?.imageView, let view = self?.view, let stackView = self?.stackView {
                            if stackView.arrangedSubviews.count > 1 {
                                self?.stackView.insertArrangedSubview(imageView, at: 1)
                            }
                            NSLayoutConstraint.activate([imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40)])
                            NSLayoutConstraint.activate([imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: (1/ratio))])
                            self?.activityIndicator.stopAnimating()
                        }
                        break
                    case .failure(_):
                        break
                    }
                })
            }
        })
        setupConstraints()
    }

    private func addSubviews()
    {
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints()
    {
        var constraints = [NSLayoutConstraint]()
        constraints.append(view.leftAnchor.constraint(equalTo: scrollView.leftAnchor))
        constraints.append(view.rightAnchor.constraint(equalTo: scrollView.rightAnchor))
        constraints.append(scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor))
        constraints.append(stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor))
        constraints.append(stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor))
        constraints.append(stackView.topAnchor.constraint(equalTo: scrollView.topAnchor))
        constraints.append(stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor))
        constraints.append(stackView.widthAnchor.constraint(equalTo: view.widthAnchor))
        constraints.append(activityIndicator.widthAnchor.constraint(equalToConstant: 100))
        constraints.append(activityIndicator.heightAnchor.constraint(equalToConstant: 100))
        constraints.append(activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        constraints.append(activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        NSLayoutConstraint.activate(constraints)
    }
}
