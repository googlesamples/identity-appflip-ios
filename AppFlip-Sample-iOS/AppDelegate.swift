/*
 * Copyright 2019 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

    print("Handling Universal Link");

    guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
      let incomingURL = userActivity.webpageURL,
      let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
      let path = components.path,
      let params = components.queryItems else {
        return false
    }
    print("path = \(path)")
    // Start AppFlipViewController
    let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    let initViewController : AppFlipViewController = mainStoryboard.instantiateViewController(
      withIdentifier: "consentPanel") as! AppFlipViewController
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = initViewController

    if let clientID = params.first(where: { $0.name == "client_id" } )?.value,
      let scope = params.first(where: { $0.name == "scope" } )?.value,
      let state = params.first(where: { $0.name == "state" } )?.value,
      let redirectUri = params.first(where: { $0.name == "redirect_uri" } )?.value {
      initViewController.flipData["clientID"] = clientID
      initViewController.flipData["scope"] = scope
      initViewController.flipData["state"] = state
      initViewController.flipData["redirectUri"] = redirectUri
      self.window?.makeKeyAndVisible()
      return true
    } else {
      print("Parameters are missing")
      return false
    }
  }
}
