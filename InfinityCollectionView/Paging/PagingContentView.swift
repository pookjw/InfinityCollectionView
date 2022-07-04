//
//  PagingContentView.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit

@MainActor
final class PagingContentView: UIView {
    private let imageView: UIImageView = .init()
    private var pagingContentConfiguration: PagingContentConfiguration? {
        didSet {
            guard let pagingContentConfiguration else {
                return
            }
            update(using: pagingContentConfiguration)
        }
    }
    
    convenience init(pagingContentConfiguration: PagingContentConfiguration) {
        self.init(frame: .null)
        self.pagingContentConfiguration = pagingContentConfiguration
        configureImageView()
    }
    
    private func configureImageView() {
        imageView.backgroundColor = .clear
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func update(using pagingContentConfiguration: PagingContentConfiguration) {
        imageView.image = pagingContentConfiguration.image
    }
}

extension PagingContentView: UIContentView {
    var configuration: UIContentConfiguration {
        get {
            return pagingContentConfiguration!
        }
        set {
            pagingContentConfiguration = newValue as? PagingContentConfiguration
        }
    }
}
