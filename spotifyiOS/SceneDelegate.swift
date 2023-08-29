import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let listViewController = ListViewController()
        let listFavViewController = ListFavViewController()
           
        listFavViewController.musicas = listViewController.musicas
           
        let tabBar = UITabBarController()
        tabBar.viewControllers = [listViewController, listFavViewController]
           
        tabBar.tabBar.backgroundColor = .systemGray6
           
        listViewController.tabBarItem = UITabBarItem(title: "Top músicas", image: UIImage(named: "iconmonstr-sound-wave-1"), tag: 0)
        listFavViewController.tabBarItem = UITabBarItem(title: "Favoritas", image: UIImage(named: "iconmonstr-heart-filled"), tag: 1)
           
        let navigationController = UINavigationController(rootViewController: tabBar)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

