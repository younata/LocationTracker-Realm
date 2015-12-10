import Quick
import Nimble
import RealmSwift
@testable import LocationTracker

class DataStoreSpec: QuickSpec {
    override func spec() {
        var subject: DataStore!
        var realm: Realm!

        beforeEach {
            let realmConf = Realm.Configuration(inMemoryIdentifier: "ThisIsWayEasierThanCoreData")
            realm = try! Realm(configuration: realmConf)
            try! realm.write {
                realm.deleteAll()
            }

            subject = DataStore(realm: realm)
        }

        it("creates locations") {
            let date = NSDate(timeIntervalSince1970: 10)
            subject.createLocation(latitude: 1, longitude: 2, date: date)

            let locations = realm.objects(Location)
            expect(locations.count).to(equal(1))

            guard let location = locations.first else { return }
            expect(location.latitude).to(equal(1))
            expect(location.longitude).to(equal(2))
            expect(location.date).to(equal(date))
        }

        it("reads locations, sorted by most recent date") {
            let loc1 = subject.createLocation(latitude: 1, longitude: 2, date: NSDate(timeIntervalSince1970: 10))
            let loc3 = subject.createLocation(latitude: 2, longitude: 3, date: NSDate(timeIntervalSince1970: 15))
            let loc2 = subject.createLocation(latitude: 3, longitude: 4, date: NSDate(timeIntervalSince1970: 12))

            expect(Array(subject.readLocation())).to(equal([loc3, loc2, loc1]))
        }

        it("deletes locations") {
            let loc1 = subject.createLocation(latitude: 1, longitude: 2, date: NSDate(timeIntervalSince1970: 10))
            let loc3 = subject.createLocation(latitude: 2, longitude: 3, date: NSDate(timeIntervalSince1970: 15))
            let loc2 = subject.createLocation(latitude: 3, longitude: 4, date: NSDate(timeIntervalSince1970: 12))

            subject.deleteLocation(loc2)
            expect(Array(subject.readLocation())).to(equal([loc3, loc1]))
        }
    }
}
