//
//  PagingViewController.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit
import Combine

@MainActor
class PagingViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private lazy var collectionView: UICollectionView = .init(frame: .null, collectionViewLayout: PagingCollectionViewLayout())
    private let topView: UIView = .init()
    private var viewModel: PagingViewModel!
    private var requstTask: Task<Void, Never>?
    private var cancellableBag: Set<AnyCancellable>?
    
    deinit {
        Task { @MainActor in
            requstTask?.cancel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTopView()
        configureViewModel()
        requestDataSource()
        bind()
    }
    
    private func configureCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .systemCyan
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureTopView() {
        topView.backgroundColor = .black.withAlphaComponent(0.5)
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func configureViewModel() {
        let cellRegistration: UICollectionView.CellRegistration<UICollectionViewCell, PagingItem> = createCellRegistration()
        let dataSource: UICollectionViewDiffableDataSource<PagingSection, PagingItem> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let viewModel: PagingViewModel = .init(dataSource: dataSource)
        self.viewModel = viewModel
    }
    
    private func requestDataSource() {
        requstTask = .detached { [weak self] in
            await self?.viewModel?.request()
            await MainActor.run { [weak self] in
                guard let collectionView: UICollectionView = self?.collectionView else {
                    return
                }
                
                (0..<collectionView.numberOfSections).forEach { section in
                    collectionView.orthogonalScrollToItem(at: IndexPath(row: 1, section: section), at: .init(rawValue: 0), animated: false)
                }
                collectionView.scrollToItem(at: IndexPath(row: 1, section: 1), at: .init(rawValue: 0), animated: false)
            }
        }
    }
    
    private func bind() {
        var cancellableBag: Set<AnyCancellable> = .init()
        
        if !ProcessInfo.processInfo.isDisabledInfinityScrolling {
            orthogonalScrollViewDidScroll
                .receive(on: OperationQueue.main)
                .filter { [weak self] _, collectionView, _, _, _ in
                    return collectionView.isEqual(self?.collectionView)
                }
                .sink { me, collectionView, scrollView, section, scrollViewFromSectionMap in
                    let cellWidth: CGFloat = collectionView.bounds.width
                    
                    guard scrollView.contentSize.width >= cellWidth else { return }
                    
                    if scrollView.contentOffset.x <= 0 {
                        scrollView.setContentOffset(.init(x: scrollView.contentSize.width - (cellWidth * 2) + scrollView.contentOffset.x,
                                                          y: scrollView.contentOffset.y),
                                                    animated: false)
                    } else if scrollView.contentOffset.x + cellWidth >= scrollView.contentSize.width {
                        scrollView.setContentOffset(.init(x: (cellWidth * 2) + scrollView.contentOffset.x - scrollView.contentSize.width,
                                                          y: scrollView.contentOffset.y),
                                                    animated: false)
                    }
                    
                    //
                    
                    let synchronizedSection: Int?
                    
                    if section as! Int == 1 {
                        synchronizedSection = collectionView.numberOfSections - 1
                    } else if section as! Int == collectionView.numberOfSections - 2 {
                        synchronizedSection = 0
                    } else {
                        synchronizedSection = nil
                    }
                    
                    guard let synchronizedSection else {
                        return
                    }
                    
                    let page: Int = Int(scrollView.contentOffset.x / cellWidth)
                    collectionView.orthogonalScrollToItem(at: IndexPath(row: page, section: synchronizedSection), at: .init(rawValue: 0), animated: false)
                }
                .store(in: &cancellableBag)
            
            configuredOrthogonalScrollView
                .receive(on: OperationQueue.main)
                .filter { [weak self] _, collectionView, _, _, _ in
                    return collectionView.isEqual(self?.collectionView)
                }
                .sink { me, collectionView, scrollView, section, scrollViewFromSectionMap in
                    let synchronizedSection: Int
                    
                    if section == 0 {
                        synchronizedSection = collectionView.numberOfSections - 2
                    } else if section == collectionView.numberOfSections - 1 {
                        synchronizedSection = 1
                    } else {
                        return
                    }
                    
                    guard let synchronizedScrollView: UIScrollView = scrollViewFromSectionMap.object(forKey: NSNumber(integerLiteral: synchronizedSection)) else {
                        return
                    }
                    
                    let cellWidth: CGFloat = collectionView.bounds.width
                    let index: Int = Int(synchronizedScrollView.contentOffset.x / cellWidth)
                    
                    collectionView.orthogonalScrollToItem(at: IndexPath(row: index, section: section), at: .init(rawValue: 0), animated: false)
                }
                .store(in: &cancellableBag)
        }
        
        self.cancellableBag = cancellableBag
    }
    
    private func createCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewCell, PagingItem> {
        return .init { cell, indexPath, itemIdentifier in
            let configuration: PagingContentConfiguration = .init(image: itemIdentifier.image)
            cell.contentConfiguration = configuration
        }
    }
    
    private func addInfinityOrthogonalScrolling(to section: Int, collectionView: UICollectionView) {
        
    }
}

extension PagingViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.isEqual(collectionView) {
            let cellHeight: CGFloat = collectionView.bounds.height
            
            let index: Int
            
            if velocity.y > .zero {
                index = Int(collectionView.contentOffset.y / cellHeight) + 1
            } else if velocity.y < .zero {
                index = Int(collectionView.contentOffset.y / cellHeight)
            } else {
                let offset: CGFloat = collectionView.contentOffset.y.truncatingRemainder(dividingBy: cellHeight)
                
                if offset > (cellHeight / 2.0) {
                    index = Int(collectionView.contentOffset.y / cellHeight) + 1
                } else {
                    index = Int(collectionView.contentOffset.y / cellHeight)
                }
            }
            
            targetContentOffset.pointee.y = cellHeight * CGFloat(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !ProcessInfo.processInfo.isDisabledInfinityScrolling {
            if scrollView.isEqual(collectionView) {
                let cellHeight: CGFloat = collectionView.bounds.height
                
                guard collectionView.contentSize.height >= cellHeight else { return }
                
                if collectionView.contentOffset.y <= 0 {
                    collectionView.setContentOffset(.init(x: collectionView.contentOffset.x,
                                                          y: collectionView.contentSize.height - (cellHeight * 2) + collectionView.contentOffset.y),
                                                    animated: false)
                } else if collectionView.contentOffset.y + cellHeight >= collectionView.contentSize.height {
                    collectionView.setContentOffset(.init(x: collectionView.contentOffset.x,
                                                          y: (cellHeight * 2) + collectionView.contentOffset.y - collectionView.contentSize.height),
                                                    animated: false)
                }
            }
        }
    }
}
