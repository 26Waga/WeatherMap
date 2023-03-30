
//

import UIKit
import CoreLocation

class Favourites: UIViewController {

    var locations:[FavouritesModel] = []
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var favouriteCellregistration: UICollectionView.CellRegistration<FavouritesLocationCell, FavouritesModel>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favourites"
        
        setupCollectionView()
        
        locations = CoreDataService.shared.fetchLocations()
        collectionView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
       
    }
    
        
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingLeading: 8.0, paddingBottom: 8.0, paddingTrailing: 8.0)
        
        favouriteCellregistration = UICollectionView.CellRegistration(handler: { (cell: FavouritesLocationCell, indexPath, favourite: FavouritesModel) in
            
            
            let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: favourite.latitude, longitude: favourite.longitude)
            
            cell.coordinates = coordinates
            
            var placemark = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            placemark.fetchLocationInformation { city, country, error in
                guard let city = city, let country = country, error == nil else {
                    return
                }
                
                cell.city = city
                cell.country = country
                
            }
            
        })
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        locations = CoreDataService.shared.fetchLocations()
        collectionView.reloadData()
    }


}

extension Favourites: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGFloat((Float(view.frame.size.width) - Float(16.0) * 3) / 2.0)
        
        return CGSize(width: size, height: size)
        
    }
}

extension Favourites: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailView()
        
        vc.locationCoordinates = CLLocationCoordinate2D(latitude: locations[indexPath.row].latitude, longitude: locations[indexPath.row].longitude)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Favourites: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favouritesLocation = locations[indexPath.row]
        
        return collectionView.dequeueConfiguredReusableCell(using: favouriteCellregistration, for: indexPath, item: favouritesLocation)
        
        
    }
    
}
