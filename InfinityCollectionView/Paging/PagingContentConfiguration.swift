//
//  PagingContentConfiguration.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit

struct PagingContentConfiguration: UIContentConfiguration {
    let image: UIImage?
    
    @MainActor func makeContentView() -> UIView & UIContentView {
        let contentView: PagingContentView = .init(pagingContentConfiguration: self)
        return contentView
    }
    
    func updated(for state: UIConfigurationState) -> PagingContentConfiguration {
        return self
    }
}
