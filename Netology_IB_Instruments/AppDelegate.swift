//
//  AppDelegate.swift
//  Netology_IB_Instruments
//
//  Created by Admin on 07.02.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.checkRealmMigration()
        window = UIWindow()
        
//        var appConfiguration:AppConfiguration { return [.first(URL(string: "https://swapi.dev/api/people/8")!), .second(URL(string: "https://swapi.dev/api/starships/3")!), .third(URL(string: "https://swapi.dev/api/planets/5")!)].randomElement()! }
//
//        NetworkService.request(for: appConfiguration)
        
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator!.start()
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.

        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

        //print(#function)

    }
    func applicationDidEnterBackground(_ application: UIApplication) {

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.

        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        //print(#function)

    }
    func applicationWillEnterForeground(_ application: UIApplication) {

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        //print(#function)

    }
    func applicationDidBecomeActive(_ application: UIApplication) {

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        //print(#function)

    }
    func applicationWillTerminate(_ application: UIApplication) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        //print(#function)

    }
    
    private func checkRealmMigration() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 4 {
                    // on future migration
                }
        })

        Realm.Configuration.defaultConfiguration = config
    }
}

