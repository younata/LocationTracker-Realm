import Quick
import Nimble
import MapKit
import RealmSwift
@testable import LocationTracker

class MapCoordinatorSpec: QuickSpec {
    override func spec() {
        var subject: MapCoordinator!
        var mapView: MKMapView!
        var realm: Realm!
        var dataStore: DataStore!

        beforeEach {
            mapView = MKMapView()

            let realmConf = Realm.Configuration(inMemoryIdentifier: "ThisIsWayEasierThanCoreData")
            realm = try! Realm(configuration: realmConf)
            try! realm.write {
                realm.deleteAll()
            }

            dataStore = DataStore(realm: realm)

            subject = MapCoordinator()
        }

        describe("adding overlays to a map") {
            it("does not add anything when given an empty array of locations") {
                subject.addLocations(dataStore.readLocation(), toMap: mapView)

                expect(mapView.overlays).to(beEmpty())
            }

            it("does not add anything when given only one location to add") {
                dataStore.createLocation(latitude: 0, longitude: 1, date: NSDate())
                subject.addLocations(dataStore.readLocation(), toMap: mapView)

                expect(mapView.overlays).to(beEmpty())
            }

            it("adds a single overlay of all locations in a line") {
                dataStore.createLocation(latitude: 0, longitude: 1, date: NSDate())
                dataStore.createLocation(latitude: 0, longitude: 2, date: NSDate())

                subject.addLocations(dataStore.readLocation(), toMap: mapView)

                expect(mapView.overlays.count).to(equal(1))
            }
        }
    }
}
