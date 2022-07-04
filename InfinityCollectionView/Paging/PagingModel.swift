//
//  PagingModel.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit

enum PagingSection: Hashable, Equatable, Identifiable {
    case numbers(UUID), symbols(UUID), arrows(UUID), conditions(UUID)
    
    var id: Int {
        hashValue
    }
    
    func copy(uuid: UUID) -> PagingSection {
        switch self {
        case .numbers:
            return .numbers(uuid)
        case .symbols:
            return .symbols(uuid)
        case .arrows:
            return .arrows(uuid)
        case .conditions:
            return .conditions(uuid)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .numbers(let uuid):
            hasher.combine(uuid)
        case .symbols(let uuid):
            hasher.combine(uuid)
        case .arrows(let uuid):
            hasher.combine(uuid)
        case .conditions(let uuid):
            hasher.combine(uuid)
        }
    }
    
    static func ==(lhs: PagingSection, rhs: PagingSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

enum PagingItem: Hashable, Equatable, Identifiable {
    case one(UUID), two(UUID), three(UUID), four(UUID)
    
    case heart(UUID), star(UUID), circle(UUID), square(UUID)
    
    case top(UUID), left(UUID), right(UUID), down(UUID)
    
    case moon(UUID), cloud(UUID), rain(UUID), snow(UUID)
    
    var image: UIImage? {
        let systemName: String
        
        switch self {
        case .one:
            systemName = "1.circle.fill"
        case .two:
            systemName = "2.circle.fill"
        case .three:
            systemName = "3.circle.fill"
        case .four:
            systemName = "4.circle.fill"
        case .heart:
            systemName = "heart.fill"
        case .star:
            systemName = "star.fill"
        case .circle:
            systemName = "circle.fill"
        case .square:
            systemName = "square.fill"
        case .top:
            systemName = "arrow.up"
        case .left:
            systemName = "arrow.left"
        case .right:
            systemName = "arrow.right"
        case .down:
            systemName = "arrow.down"
        case .moon:
            systemName = "moon"
        case .cloud:
            systemName = "cloud"
        case .rain:
            systemName = "cloud.rain"
        case .snow:
            systemName = "cloud.snow"
        }
        
        return .init(systemName: systemName)
    }
    
    var id: Int {
        hashValue
    }
    
    func copy(uuid: UUID) -> PagingItem {
        switch self {
        case .one:
            return .one(uuid)
        case .two:
            return .two(uuid)
        case .three:
            return .three(uuid)
        case .four:
            return .four(uuid)
        case .heart:
            return .heart(uuid)
        case .star:
            return .star(uuid)
        case .circle:
            return .circle(uuid)
        case .square:
            return .square(uuid)
        case .top:
            return .top(uuid)
        case .left:
            return .left(uuid)
        case .right:
            return .right(uuid)
        case .down:
            return .down(uuid)
        case .moon:
            return .moon(uuid)
        case .cloud:
            return .cloud(uuid)
        case .rain:
            return .rain(uuid)
        case .snow:
            return .snow(uuid)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .one(let uuid):
            hasher.combine(uuid)
        case .two(let uuid):
            hasher.combine(uuid)
        case .three(let uuid):
            hasher.combine(uuid)
        case .four(let uuid):
            hasher.combine(uuid)
        case .heart(let uuid):
            hasher.combine(uuid)
        case .star(let uuid):
            hasher.combine(uuid)
        case .circle(let uuid):
            hasher.combine(uuid)
        case .square(let uuid):
            hasher.combine(uuid)
        case .top(let uuid):
            hasher.combine(uuid)
        case .left(let uuid):
            hasher.combine(uuid)
        case .right(let uuid):
            hasher.combine(uuid)
        case .down(let uuid):
            hasher.combine(uuid)
        case .moon(let uuid):
            hasher.combine(uuid)
        case .cloud(let uuid):
            hasher.combine(uuid)
        case .rain(let uuid):
            hasher.combine(uuid)
        case .snow(let uuid):
            hasher.combine(uuid)
        }
    }
    
    static func ==(lhs: PagingItem, rhs: PagingItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
