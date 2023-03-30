
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI





class MapView: UIViewController {
    
   
    let map = MKMapView()
    let locationManager = CLLocationManager()
    let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
        
    var currentMap:MKMapType = .satellite {
        didSet {
            map.mapType = currentMap
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.mapType = .standard
        view.addSubview(map)
        
        map.delegate = self
        
        map.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        setUpRegion()
        addSegmentControl()
        locationButton()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        longPress.addTarget(self, action: #selector(didAddAnnotation))
        map.addGestureRecognizer(longPress)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        populateMapWithAnnotations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextObjectsDidChange(_:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        
       
    }
    
    func setUpRegion() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 47.907, longitude: 106.88)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        map.setRegion(region, animated: true)
        map.showsUserLocation = true
        
        
    }
    
    
    
    
    
    func addSegmentControl(){
        let segments = ["Standard", "Satellite"]
        let control = UISegmentedControl(items: segments)
        
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemPurple
        control.addTarget(self, action: #selector(handleMapChange(_:)), for: .valueChanged)
        
        view.addSubview(control)
        control.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        control.centerX(inView: view)
        
    }
    
    func locationButton() {
        let locationButton = CLLocationButton()
        locationButton.setSize(height: 50, width: 50)
        
        locationButton.cornerRadius = 25
        locationButton.icon = .arrowFilled
        locationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        
        view.addSubview(locationButton)
        locationButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, paddingBottom: 24, paddingTrailing: 8)
        locationButton.backgroundColor = .white
        locationButton.tintColor = .systemPurple
        
        
    }
    
    
    
    
    func createAnnotation(cityFromCoreData: String? = nil, countryFromCoreData: String? = nil, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> MKPointAnnotation {
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let locationFromCity = CLLocation(latitude: latitude, longitude: longitude)
        
        let marker: MKPointAnnotation = MKPointAnnotation()
        
        if let city = cityFromCoreData, let country = countryFromCoreData {
            marker.title = city
            marker.subtitle = country
        } else {
            locationFromCity.fetchLocationInformation { city, country, error in
                
                guard let city = city, let country = country, error == nil else {
                    return
                }
                
                marker.title = city
                marker.subtitle = country
                
            }
        }
        marker.coordinate = locationCoordinates
        
        
        return marker
    }
    
    func populateMapWithAnnotations() {
        let annotations = map.annotations
        map.removeAnnotations(annotations)
        
        let favouriteLocations = CoreDataService.shared.fetchLocations()
        
        for location in favouriteLocations {
            map.addAnnotation(createAnnotation(cityFromCoreData: location.name, countryFromCoreData: location.country, latitude: location.latitude, longitude: location.longitude))
            
        }
        
    }
    
    
    
    @objc func handleMapChange(_ segmentedControl: UISegmentedControl) {
        switch(segmentedControl.selectedSegmentIndex) {
        case 0:
            currentMap = .standard
        case 1:
            currentMap = .satellite
        default:
            currentMap = .standard
        }
        
        
        
    }
    
    @objc func getCurrentLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    @objc func didAddAnnotation(sender: UILongPressGestureRecognizer){
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        let pressedLocation = sender.location(in: map)
        
        let pressedCoordinates: CLLocationCoordinate2D = map.convert(pressedLocation, toCoordinateFrom: map)
        
        map.addAnnotation(createAnnotation( latitude: pressedCoordinates.latitude, longitude: pressedCoordinates.longitude))
        
    }
    
    @objc func contextObjectsDidChange(_ notification: Notification) {
        populateMapWithAnnotations()
    }
    
       
}

extension MapView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        map.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get User Location")
    }
    
}

extension MapView:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        
        annotationView.glyphImage = UIImage(systemName: "network")
        
        
        annotationView.markerTintColor = .systemPurple
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let vc = DetailView()
        
        vc.locationCoordinates = view.annotation?.coordinate
        
        
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

