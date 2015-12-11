import UIKit
import RealmSwift
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.makeKeyAndVisible()

        let viewController = ViewController()

        viewController.dataStore = DataStore(realm: try! Realm())
        viewController.mapCoordinator = MapCoordinator()
        viewController.locationTracker = LocationTracker(locationManager: CLLocationManager())

        self.window?.rootViewController = viewController

        return true
    }
}

