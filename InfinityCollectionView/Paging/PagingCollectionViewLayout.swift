//
//  PagingCollectionViewLayout.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit

final class PagingCollectionViewLayout: UICollectionViewCompositionalLayout {
    convenience init() {
        let configuration: UICollectionViewCompositionalLayoutConfiguration = .init()
        configuration.scrollDirection = .vertical
        
        self.init(sectionProvider: { section, env in
            let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item: NSCollectionLayoutItem = .init(layoutSize: itemSize, supplementaryItems: [])
            let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let group: NSCollectionLayoutGroup
            
            if #available(iOS 16.0, *) {
                group = .horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
            } else {
                group = .horizontal(layoutSize: groupSize, subitem: item, count: 1)
            }
            
            let section: NSCollectionLayoutSection = .init(group: group)
            section.orthogonalScrollingBehavior = .paging
            
            return section
        }, configuration: configuration)
    }
}
