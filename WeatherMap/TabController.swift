
//

import UIKit

class MainTabbar: UITabBarController {
    
    let configuration = UIImage.SymbolConfiguration(weight: .black)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTabs()
        
        
    }

    
   private func setUpTabs(){
        viewControllers = [
            
            
            createNavigationController(for: MapView(), title: "Maps", image: UIImage(systemName: "map.circle", withConfiguration: configuration)!, selectedImage: UIImage(systemName: "map.circle.fill", withConfiguration: configuration)!),
            createNavigationController(for: SearchView(), title: "Search", image: UIImage(systemName: "magnifyingglass.circle", withConfiguration: configuration)!, selectedImage: UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: configuration)!),
            
            createNavigationController(for: Favourites(), title: "Favourites", image: UIImage(systemName: "heart.circle", withConfiguration: configuration)!, selectedImage: UIImage(systemName: "heart.circle.fill", withConfiguration: configuration)!)
            
        ]
        
        
    }
    
    private func createNavigationController(for rootViewController: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        navController.navigationBar.prefersLargeTitles = false
        navController.navigationItem.title = title
        
        UITabBar.appearance().tintColor = .systemPurple
        UITabBar.appearance().backgroundColor = .white
    
        return navController
        
    }

}

