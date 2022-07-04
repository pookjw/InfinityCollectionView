//
//  ProcessInfo+isDisabledInfinityScrolling.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/4/22.
//

import Foundation

extension ProcessInfo {
    var isDisabledInfinityScrolling: Bool {
        return arguments.contains("--disableInfinityScrolling")
    }
}
