// Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialColorScheme
import MaterialComponents.MaterialDialogs
import MaterialComponents.MaterialCollections
import MaterialComponents.MaterialDialogs_DialogThemer
import MaterialComponents.MaterialTypographyScheme

class CustomAlertViewController: UIViewController {

  let bodyLabel = UILabel()
  let dismissButton = MDCFlatButton()

  var cornerRadius: CGFloat {
    set { view.layer.cornerRadius = newValue }
    get { return view.layer.cornerRadius }
  }

  override var preferredContentSize: CGSize {
    get { return CGSize(width:200.0, height:140.0); }
    set { super.preferredContentSize = newValue }
  }

  override func viewDidLoad() {

    super.viewDidLoad()
    view.backgroundColor = UIColor.white

    bodyLabel.text = "This is a view controller."
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.numberOfLines = 0
    bodyLabel.sizeToFit()
    self.view.addSubview(bodyLabel)

    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "H:|-[body]-|", options: [],
                                     metrics: nil, views: ["body": bodyLabel]))
    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "V:|-[body]-|", options: [],
                                     metrics: nil, views: ["body": bodyLabel]))
  }
}

class DialogsAlertCustomizationViewController: MDCCollectionViewController {

  var colorScheme = MDCSemanticColorScheme()
  var typographyScheme = MDCTypographyScheme()
  var alertScheme: MDCAlertScheme {
    let scheme = MDCAlertScheme()
    scheme.colorScheme = self.colorScheme
    scheme.typographyScheme = self.typographyScheme
    return scheme
  }

  let kReusableIdentifierItem = "customCell"

  var menu: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.white

    loadCollectionView(menu: [
      "Centered Title",
      "Centered Title With a Title Icon",
      "Naturally Aligned Title with an Icon",
      "Right Aligned Title with a Large Icon",
      "Tinted Title Icon, No Title",
      "Darker Scrim",
    ])
  }

  func loadCollectionView(menu: [String]) {
    self.collectionView?.register(MDCCollectionViewTextCell.self, forCellWithReuseIdentifier: kReusableIdentifierItem)
    self.menu = menu
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let alert = performActionFor(row: indexPath.row) else { return }
    self.present(alert, animated: true, completion: nil)
  }

  private func performActionFor(row: Int) -> MDCAlertController? {
    switch row {
    case 0:
      return performCenteredTitle()
    case 1:
      return performCenteredTitleWithIcon()
    case 2:
      return performNaturalTitleWithIcon()
    case 3:
      return performRightTitleWithResizedIcon()
    case 4:
      return performTintedTitleIconNoTitle()
    case 5:
      return performScrimColor()
    default:
      print("No row is selected")
      return nil
    }
  }

  func sampleIcon(isStandardSize: Bool = true) -> UIImage? {
    let bundle = Bundle(for: DialogsAlertCustomizationViewController.self)
    return UIImage(
      named: isStandardSize ? "outline_lock_black_24pt" : "baseline_alarm_on_black_48pt",
      in: bundle, compatibleWith: nil)
  }

  func performCenteredTitle() -> MDCAlertController {
    let alert = createMDCAlertController(title: "Center Aligned Title")
    alert.titleAlignment = .center
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)
    return alert
  }

  func performCenteredTitleWithIcon() -> MDCAlertController {
    let alert = createMDCAlertController(title: "Center Aligned Title")
    alert.titleIcon = sampleIcon()
    alert.titleAlignment = .center
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)
    return alert
  }

  func performNaturalTitleWithIcon() -> MDCAlertController {
    let alert = createMDCAlertController(title: "Default (Natural) Title Alignment")
    alert.titleIcon = sampleIcon()
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)
    return alert
  }

  func performRightTitleWithResizedIcon() -> MDCAlertController {
    let alert = createMDCAlertController(title: "Right Aligned Title")
    alert.titleIcon = sampleIcon(isStandardSize: false)
    alert.titleAlignment = .right
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)
    return alert
  }

  func performTintedTitleIconNoTitle() -> MDCAlertController {
    let alert = createMDCAlertController(title: nil)
    alert.titleIcon = sampleIcon()
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)

    // theming override: set the titleIconTintColor after the color scheme has been applied
    alert.titleIconTintColor = .red

    return alert
  }

  func performScrimColor() -> MDCAlertController {
    let alert = createMDCAlertController(title: "Darker Scrim")
    MDCAlertControllerThemer.applyScheme(alertScheme, to: alert)
    alert.mdc_dialogPresentationController?.scrimColor = UIColor.black.withAlphaComponent(0.6)
    return alert
  }

  private func createMDCAlertController(title: String?) -> MDCAlertController {
    let alertController = MDCAlertController(title: title, message: """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
      tempor incididunt ut labore et dolore magna aliqua.
      """)
    alertController.addAction(MDCAlertAction(title:"OK") { _ in print("OK") })
    alertController.addAction(MDCAlertAction(title:"Cancel") { _ in print("Cancel") })
    return alertController
  }

}

// MDCCollectionViewController Data Source
extension DialogsAlertCustomizationViewController {

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menu.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReusableIdentifierItem,
                                                  for: indexPath)
    guard let customCell = cell as? MDCCollectionViewTextCell else { return cell }

    customCell.textLabel?.text = menu[indexPath.row]

    return customCell
  }
}

// MARK: Catalog by convention
extension DialogsAlertCustomizationViewController {

  class func catalogMetadata() -> [String: Any] {
    return [
      "breadcrumbs": ["Dialogs", "Alert Customization"],
      "primaryDemo": false,
      "presentable": false,
    ]
  }
}
