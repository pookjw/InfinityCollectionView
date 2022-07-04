//
//  SceneDelegate.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/3/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        let window: UIWindow = .init(windowScene: windowScene)
        let rootViewController: PagingViewController = .init()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

