import UIKit
@testable import Frames

class BillingFormTableViewMockDelegate: BillingFormTableViewDelegate {
    var numberOfRowsInSectionCalledTimes = 0
    var numberOfRowsInSectionLastCalledWithSection: Int?

    var estimatedHeightForRowCalledTimes = 0
    var estimatedHeightForRowLastCalledWithIndexPath: IndexPath?

    var heightForHeaderInSectionCalledTimes = 0
    var heightForHeaderInSectionLastCalledWithTableView: UITableView?
    var heightForHeaderInSectionLastCalledWithSection: Int?

    var cellForRowAtCalledTimes = 0
    var cellForRowAtLastCalledWithTableView: UITableView?
    var cellForRowAtLastCalledWithIndexPath: IndexPath?
    var cellForRowAtLastCalledWithSender: UIViewController?

    func tableView(numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSectionCalledTimes += 1
        numberOfRowsInSectionLastCalledWithSection = section
        return 5
    }

    func tableView(cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        cellForRowAtCalledTimes += 1
        cellForRowAtLastCalledWithIndexPath = indexPath
        cellForRowAtLastCalledWithSender = sender
        return UITableViewCell()
    }

    func tableView(estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        estimatedHeightForRowCalledTimes += 1
        estimatedHeightForRowLastCalledWithIndexPath = indexPath
        return 100
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        heightForHeaderInSectionCalledTimes += 1
        heightForHeaderInSectionLastCalledWithTableView = tableView
        heightForHeaderInSectionLastCalledWithSection = section
        return 10.0
    }

    func tableView(tableView: UITableView, cellForRowAt indexPath: IndexPath, sender: UIViewController) -> UITableViewCell {
        cellForRowAtCalledTimes += 1
        cellForRowAtLastCalledWithTableView = tableView
        cellForRowAtLastCalledWithIndexPath = indexPath
        cellForRowAtLastCalledWithSender = sender
        return UITableViewCell()
    }

}
