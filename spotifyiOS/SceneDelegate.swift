//
//  SceneDelegate.swift
//  spotifyiOS
//
//  Created by Lucas Ferreira on 04/07/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window?.rootViewController = ListViewController()
        window?.makeKeyAndVisible()
    }

}

