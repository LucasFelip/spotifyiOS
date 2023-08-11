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
        
        // Configurar os ícones e títulos das guias
        // Configurar ícones personalizados
        //listViewController.tabBarItem = UITabBarItem(title: "Lista", image: UIImage(named: "icon_lista"), tag: 0)
        //listFavViewController.tabBarItem = UITabBarItem(title: "Favoritas", image: UIImage(named: "icon_favoritas"), tag: 1)
        listViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        listFavViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        let navigationController = UINavigationController(rootViewController: tabBar)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }



}

