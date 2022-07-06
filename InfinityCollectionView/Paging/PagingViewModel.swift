//
//  PagingViewModel.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit
import Combine

actor PagingViewModel {
    let dataSource: UICollectionViewDiffableDataSource<PagingSection, PagingItem>
    
    init(dataSource: UICollectionViewDiffableDataSource<PagingSection, PagingItem>) {
        self.dataSource = dataSource
    }
    
    func request() async {
        var snapshot: NSDiffableDataSourceSnapshot<PagingSection, PagingItem> = dataSource.snapshot()
        
        let numbersSection: PagingSection = .numbers(.init())
        let symbolsSection: PagingSection = .symbols(.init())
        let arrowsSection: PagingSection = .arrows(.init())
        let conditionsSection: PagingSection = .conditions(.init())
        
        snapshot.deleteAllItems()
        snapshot.appendSections([numbersSection, symbolsSection, arrowsSection, conditionsSection])
        snapshot.appendItems([.one(.init()), .two(.init()), .three(.init()), .four(.init())], toSection: numbersSection)
        snapshot.appendItems([.heart(.init()), .star(.init()), .circle(.init()), .square(.init())], toSection: symbolsSection)
        snapshot.appendItems([.top(.init()), .left(.init()), .right(.init()), .down(.init())], toSection: arrowsSection)
        snapshot.appendItems([.moon(.init()), .cloud(.init()), .rain(.init()), .snow(.init())], toSection: conditionsSection)
        
        if !ProcessInfo.processInfo.isDisabledInfinityScrolling {
            let sectionIdentifiers: [PagingSection] = snapshot.sectionIdentifiers
            guard let firstSection: PagingSection = sectionIdentifiers.first,
                  let lastSection: PagingSection = sectionIdentifiers.last else {
                return
            }
            
            let firstSectionCopy: PagingSection = firstSection.copy(uuid: .init())
            let lastSectionCopy: PagingSection = lastSection.copy(uuid: .init())
            
            let firstItemsCopy: [PagingItem] = snapshot.itemIdentifiers(inSection: firstSection)
                .map { $0.copy(uuid: .init()) }
            let lastItemsCopy: [PagingItem] = snapshot.itemIdentifiers(inSection: lastSection)
                .map { $0.copy(uuid: .init()) }
            
            snapshot.insertSections([firstSectionCopy], afterSection: lastSection)
            snapshot.insertSections([lastSectionCopy], beforeSection: firstSection)
            
            snapshot.appendItems(firstItemsCopy, toSection: firstSectionCopy)
            snapshot.appendItems(lastItemsCopy, toSection: lastSectionCopy)
            
            //
            
            snapshot.sectionIdentifiers.forEach { section in
                guard let firstItem: PagingItem = snapshot.itemIdentifiers(inSection: section).first,
                      let lastItem: PagingItem = snapshot.itemIdentifiers(inSection: section).last else {
                    return
                }
                
                let firstItemCopy: PagingItem = firstItem.copy(uuid: .init())
                let lastItemCopy: PagingItem = lastItem.copy(uuid: .init())
                
                snapshot.insertItems([firstItemCopy], afterItem: lastItem)
                snapshot.insertItems([lastItemCopy], beforeItem: firstItem)
            }
        }
        
        return await withCheckedContinuation { continuation in
            dataSource.applySnapshotUsingReloadData(snapshot) {
                continuation.resume(returning: ())
            }
        }
    }
}
