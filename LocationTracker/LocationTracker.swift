import Foundation
import CoreLocation

protocol LocationManager: class {
    var authorized: Bool { get }

    var delegate: CLLocationManagerDelegate? { get set }
    // unfortunately, this exposes that this is intended to be a CLLocationManager
    // However, you can't (yet?) do protocol inheritence in swift, so I pretty much
    // have to do this ):

    func authorize()
    func startUpdating()
    func stopUpdating()
}

// Turns out that testing exactly how CLLocationManager conforms to LocationManager
// isn't exactly possible in swift, so we're not going to do that.

// Besides, it's simple enough to make sure we're doing the right things.
extension CLLocationManager: LocationManager {
    var authorized: Bool {
        return CLLocationManager.authorizationStatus() == .AuthorizedAlways
    }

    func authorize() {
        self.requestAlwaysAuthorization()
    }

    func startUpdating() {
        self.startMonitoringSignificantLocationChanges()
    }

    func stopUpdating() {
        self.stopMonitoringSignificantLocationChanges()
    }
}

final class LocationTracker: NSObject, CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            self.locationManager.startUpdating()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.onLocationUpdate?(location)
    }

    var onLocationUpdate: ((CLLocation) -> (Void))? = nil

    let locationManager: LocationManager

    required init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()

        locationManager.delegate = self
        if !locationManager.authorized {
            locationManager.authorize()
        } else {
            locationManager.startUpdating()
        }
    }
}