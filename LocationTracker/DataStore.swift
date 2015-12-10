import RealmSwift
import Foundation

class Location: Object {
    internal private(set) dynamic var date = NSDate(timeIntervalSinceNow: 0)
    internal private(set) dynamic var latitude: Double = 0
    internal private(set) dynamic var longitude: Double = 0
}

class DataStore {
    let realm: Realm

    func createLocation(latitude latitude: Double, longitude: Double, date: NSDate) -> Location {
        let location = Location()
        location.latitude = latitude
        location.longitude = longitude
        location.date = date
        self.update {
            self.realm.add(location)
        }
        return location
    }

    func readLocation() -> Results<Location> {
        return self.realm.objects(Location).sorted("date", ascending: false)
    }

    private func update(transaction: (Void) -> (Void)) {
        let _ = try? self.realm.write(transaction)
    }

    func deleteLocation(location: Location) {
        self.update {
            self.realm.delete(location)
        }
    }

    init(realm: Realm) {
        self.realm = realm
    }
}
