//
//  SelectSchemeViewController.swift
//  CheckoutCocoapodsSample
//
//  Created by Daven.Gomes on 01/12/2021.
//

import UIKit
import Checkout

class SelectSchemeViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  private lazy var allSchemes: [Card.Scheme] = {
    var schemes = Set(Card.Scheme.allCases)
    schemes.remove(.unknown)
    return Array(schemes)
  }()
  var selectedSchemes: Set<Card.Scheme> = []
  var didSelectSchemes: ((Set<Card.Scheme>) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Select Schemes"

    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension SelectSchemeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    allSchemes.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "SchemeCell")

    let scheme = allSchemes[indexPath.row]
    cell.textLabel?.text = scheme.rawValue.localizedCapitalized
    cell.accessoryType = selectedSchemes.contains(scheme) ? .checkmark : .none

    return cell
  }
}

extension SelectSchemeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let scheme = allSchemes[indexPath.row]

    if selectedSchemes.contains(scheme) {
      selectedSchemes.remove(scheme)
    } else {
      selectedSchemes.insert(scheme)
    }

    tableView.reloadRows(at: [indexPath], with: .automatic)
    didSelectSchemes?(selectedSchemes)
  }
}
