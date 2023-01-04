import UIKit
import PassKit
import FramesIos

class ExampleViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    CardViewControllerDelegate,
    CvvConfirmationViewControllerDelegate,
    ThreedsWebViewControllerDelegate {

    func onConfirm(controller: CvvConfirmationViewController, cvv: String) {
        if let card = selectedCard as? CustomerCard {
            merchantAPIClient.payWith3ds(value: 509, cardId: card.id, cvv: cvv, customer: customerEmail) { response in
                self.threeDsViewController.url = response.redirectUrl
                self.present(self.threeDsViewController, animated: true)
            }
        }
    }

    func onCancel(controller: CvvConfirmationViewController) {
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var cardsTableView: UITableView!

    let publicKey = "pk_sbox_ym4kqv5lzvjni7utqbliqs2vhqc"
    var checkoutAPIClient: CheckoutAPIClient { return CheckoutAPIClient(publicKey: publicKey, environment: .sandbox) }
    var availableSchemes: [CardScheme] = []

    let merchantAPIClient = MerchantAPIClient()
    let customerEmail = "just@test.com"

    var customerCardList: CustomerCardList?
    var selectedCard: Any?

    let cardViewController = CardViewController(cardHolderNameState: .hidden, billingDetailsState: .normal)
    let cvvConfirmationViewController = CvvConfirmationViewController()
    let threeDsViewController = ThreedsWebViewController(
        successUrl: "https://github.com/checkout/just-a-test/",
        failUrl: "https://github.com/checkout/just-a-test/master/"
    )
    let simpleLoadingViewController = SimpleLoadingViewController()

    @IBAction func onTapAddCard(_ sender: Any) {
        navigationController?.pushViewController(cardViewController, animated: true)
    }

    @IBAction func onTapPayWithCard(_ sender: Any) {
        navigationController?.pushViewController(cvvConfirmationViewController, animated: true)
        if let card = selectedCard as? CustomerCard {
            merchantAPIClient.payWith3ds(value: 509, cardId: card.id, cvv: "100", customer: customerEmail) { response in
                self.threeDsViewController.url = response.redirectUrl
                self.present(self.threeDsViewController, animated: true)
            }
        }
    }

    func addOkAlertButton(alert: UIAlertController) {
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // setup table view
        cardsTableView.register(CardListCell.self, forCellReuseIdentifier: "cardCell")
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        cardsTableView.estimatedRowHeight = 50
        cardViewController.availableSchemes = [.visa, .mastercard]
        // set delegates
        cardViewController.delegate = self
        threeDsViewController.delegate = self
        cvvConfirmationViewController.delegate = self
        // update the card list
        updateCustomerCardList()
    }

    func updateCustomerCardList() {
        self.present(simpleLoadingViewController, animated: false, completion: nil)
        merchantAPIClient.get(customer: customerEmail) { customer in
            self.customerCardList = customer.cards
            self.cardsTableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            // select the default card
            let indexDefaultCardOpt = customer.cards.data.index { card in
                card.id == customer.defaultCard
            }
            guard let indexDefaultCard = indexDefaultCardOpt else { return }
            let indexPath = IndexPath(row: indexDefaultCard, section: 0)
            self.cardsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            self.cardsTableView.invalidateIntrinsicContentSize()
        }
    }

    func onTapDone(card: CkoCardTokenRequest) {
        checkoutAPIClient.createCardToken(card: card, successHandler: { cardToken in
            // Get the card token and call the merchant api to do a zero dollar authorization charge
            // This will verify the card and save it to the customer
            self.merchantAPIClient.save(cardWith: cardToken.id, for: self.customerEmail, isId: false) {
                // update the customer card list with the new card
                self.updateCustomerCardList()
            }
        }, errorHandler: { error in
            // error creating the card token
            print(error)
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let customerCardCount = customerCardList?.count ?? 0
        return customerCardCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as? CardListCell
            else { fatalError("The dequeued cell is not an instance of CardCell.") }

            // customer card
            guard let card = customerCardList?.data[indexPath.row] else { return cell }
            cell.cardInfoLabel.text = "\(card.paymentMethod.capitalized) ····\(card.last4)"
            if let cardScheme = CardScheme(rawValue: card.paymentMethod.lowercased()) {
                cell.setSchemeIcon(scheme: cardScheme)
            }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerCardCount = customerCardList?.count ?? 0
        if indexPath.row < customerCardCount {
            guard let card = customerCardList?.data[indexPath.row] else { return }
            selectedCard = card
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the card
            customerCardList?.data.remove(at: indexPath.row)
            customerCardList?.count -= 1
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func onSuccess3D() {
        print("dismissed 😎")
    }

    func onFailure3D() {
        print("dismissed 😢")
    }

}
