import UIKit
import MapKit
import RealmSwift

class ViewController: UIViewController {
    let mapView = MKMapView()

    var locationTracker: LocationTracker? {
        didSet {
            self.locationTracker?.onLocationUpdate = {clLocation in
                let coordinate = clLocation.coordinate
                self.dataStore?.createLocation(latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    date: clLocation.timestamp)
                if let locations = self.dataStore?.readLocation() {
                    self.mapCoordinator?.addLocations(locations, toMap: self.mapView)
                }
            }
        }
    }

    var mapCoordinator: MapCoordinator? {
        didSet {
            self.mapView.delegate = self.mapCoordinator
        }
    }

    var dataStore: DataStore?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.zoomEnabled = true;
        self.mapView.scrollEnabled = true;
        self.mapView.pitchEnabled = true;
        self.mapView.rotateEnabled = true;
        self.mapView.showsUserLocation = true

        if let location = self.dataStore?.readLocation().last {
            self.mapCoordinator?.zoomMap(self.mapView, toLocation: location)
        }

        self.view.addSubview(self.mapView)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: [], metrics: nil, views: ["mapView": self.mapView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView]|", options: [], metrics: nil, views: ["mapView": self.mapView]))
    }
}

