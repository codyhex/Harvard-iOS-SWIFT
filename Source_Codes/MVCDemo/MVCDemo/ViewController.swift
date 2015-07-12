import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

class ViewController: UIViewController {
    struct Commands {
        static let connect = "Connect model"
        static let disconnect = "Disconnect model"
    }
    
    @IBOutlet weak var hueEntry: UITextField!
    @IBOutlet weak var sideEntry: UITextField!
    @IBOutlet weak var xEntry: UITextField!
    @IBOutlet weak var yEntry: UITextField!
    @IBOutlet weak var connectModelButton: UIButton!
    
    @IBOutlet weak var squareView: ColoredSquareView!
    var model: ColoredSquareDataSource?
    
    // Warning: do not call before viewDidLoad()
    func updateUI() {
        squareView.setNeedsDisplay()
        hueEntry.text = "\(model!.hue)"
        sideEntry.text = "\(model!.side)"
        xEntry.text = "\(model!.vx)"
        yEntry.text = "\(model!.vy)"
        let buttonTitle = squareView.dataSource == nil ? Commands.connect : Commands.disconnect
        connectModelButton.setTitle(buttonTitle, forState: .Normal)
    }
    
    override func viewDidLoad() {
        model = ColoredSquareModel()
        updateUI()
    }
    
    @IBAction func squareViewTapped(sender: UIGestureRecognizer) {
        let tapSpot = sender.locationInView(squareView)
        model!.vx = Double(tapSpot.x)
        model!.vy = Double(tapSpot.y)
        updateUI()
    }
    
    @IBAction func toggleModelConnection(sender: AnyObject) {
        if squareView.dataSource == nil {
            squareView.dataSource = model
        }
        else {
            squareView.dataSource = nil
        }
        updateUI()
    }
    
    @IBAction func colorChanged(sender: UITextField) {
        if let newColor = sender.text.toDouble() {
            model!.hue = newColor
        }
        updateUI()
    }
    
    @IBAction func sideChanged(sender: UITextField) {
        if let newSide = sender.text.toDouble() {
            model!.side = newSide
        }
        updateUI()
    }
    
    @IBAction func xChanged(sender: UITextField) {
        if let newX = sender.text.toDouble() {
            model!.vx = newX
        }
        updateUI()
    }
    
    @IBAction func yChanged(sender: UITextField) {
        if let newY = sender.text.toDouble() {
            model!.vy = newY
        }
        updateUI()
    }
}

