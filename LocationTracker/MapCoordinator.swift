import Foundation
import MapKit
import RealmSwift

class MapCoordinator: NSObject, MKMapViewDelegate {
    func addLocations(locations: Results<Location>, toMap map: MKMapView) {
        map.removeOverlays(map.overlays)

        guard locations.count > 1 else { return }

        let pointFromLocation: (Location) -> CLLocationCoordinate2D = {location in
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }

        var points = [CLLocationCoordinate2D]()

        for location in locations {
            points.append(pointFromLocation(location))
        }

        let overlay = MKGeodesicPolyline(coordinates: &points, count: points.count)
        map.addOverlay(overlay)
    }

    func zoomMap(map: MKMapView, toLocation: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: toLocation.latitude, longitude: toLocation.longitude)
        map.setCenterCoordinate(coordinate, animated: true)
    }

    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.greenColor()
        renderer.alpha = 0.5
        return renderer
    }
}
