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

class AppFlipViewController: UIViewController {

  var flipData = [String:String]()
  @IBOutlet weak var logField: UITextView!

  override func viewDidLoad() {
    logField.text.append(
      "Received\nclientID = \(flipData["clientID"]!)\nscope = \(flipData["scope"]!)" +
      "\nstate = \(flipData["state"]!)\nredirect_URI = \(flipData["redirectUri"]!)\n")
  }

  @IBAction func yesButton(_ sender: Any) {
    print("yesButton clicked");
    let authCode = randomString(length: 16)
    let redirectUri = flipData["redirectUri"]!
    let state = flipData["state"]!
    guard let url = URL(string: "\(redirectUri)?state=\(state)&code=\(authCode)") else {
      return
    }
    UIApplication.shared.open(url)
    self.dismiss(animated: false, completion: nil)
  }

  @IBAction func noButton(_ sender: Any) {
    print("noButton clicked");
    let redirectUri = flipData["redirectUri"]!
    let state = flipData["state"]!
    guard let url = URL(string: "\(redirectUri)?state=\(state)&error=user_not_authorized") else {
      return
    }
    UIApplication.shared.open(url, options: ["universalLinksOnly": true], completionHandler: nil)
  }

  func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{_ in letters.randomElement()!})
  }
}
