import UIKit

class ViewController: UIViewController {
    var payloadText: String? {
        didSet {
            guard label != nil else { return }
            label.text = payloadText
            view.backgroundColor = backgroundColor ?? .white
        }
    }

    var backgroundColor: UIColor?

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
