import Quick
import Nimble
@testable import LocationTracker
import CoreLocation

class FakeLocationManager: LocationManager {
    var authorized = false

    weak var delegate: CLLocationManagerDelegate? = nil

    var askedForAuthorization = false
    func authorize() {
        askedForAuthorization = true
    }

    var isUpdating: Bool? = nil

    func startUpdating() {
        isUpdating = true
    }

    func stopUpdating() {
        isUpdating = false
    }

    init() {}
}

class LocationTrackerSpec: QuickSpec {
    override func spec() {
        var subject: LocationTracker!
        var locationManager: FakeLocationManager!

        let clLocationManager = CLLocationManager()

        beforeEach {
            locationManager = FakeLocationManager()
        }

        context("if we are not yet authorized") {
            beforeEach {
                locationManager.authorized = false
                subject = LocationTracker(locationManager: locationManager)
                expect(locationManager.delegate).toNot(beNil())
            }

            it("asks if we are authorized") {
                expect(locationManager.askedForAuthorization).to(beTruthy())
            }

            it("starts updating when we accept the authorization") {
                locationManager.delegate?.locationManager?(clLocationManager, didChangeAuthorizationStatus: .AuthorizedAlways)

                expect(locationManager.isUpdating).to(beTruthy())
            }
        }

        context("once we are authorized") {
            beforeEach {
                locationManager.authorized = true
                subject = LocationTracker(locationManager: locationManager)
                expect(locationManager.delegate).toNot(beNil())
            }

            it("immediately starts updating") {
                expect(locationManager.isUpdating).to(beTruthy())
            }

            it("calls the callback when the location updates") {
                var locations = [CLLocation]()
                subject.onLocationUpdate = {location in
                    locations.append(location)
                }

                let testLocation = CLLocation(latitude: 0, longitude: 0)
                let testLocation2 = CLLocation(latitude: 1, longitude: 1)
                locationManager.delegate?.locationManager?(clLocationManager, didUpdateLocations: [testLocation, testLocation2])

                expect(locations).to(equal([testLocation2]))
            }
        }
    }
}
