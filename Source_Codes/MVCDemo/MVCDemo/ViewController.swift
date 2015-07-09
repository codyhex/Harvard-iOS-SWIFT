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
    
    var allFields = [ UITextField : String]()
    
    @IBOutlet weak var xLocField: UITextField! {
        didSet { allFields[xLocField] = ModelKeys.xLoc }
    }
    
    @IBOutlet weak var yLocField: UITextField! {
        didSet { allFields[yLocField] = ModelKeys.yLoc }
    }
    
    @IBOutlet weak var hueField: UITextField! {
        didSet { allFields[hueField] = ModelKeys.hue }
    }
    
    @IBOutlet weak var sideLengthField: UITextField! {
        didSet { allFields[sideLengthField] = ModelKeys.sideLength }
    }
    
//    @IBOutlet weak var hueEntry: UITextField!
//    @IBOutlet weak var sideEntry: UITextField!
//    @IBOutlet weak var xEntry: UITextField!
//    @IBOutlet weak var yEntry: UITextField!
//    @IBOutlet weak var connectModelButton: UIButton!
    
    @IBOutlet weak var squareView: ColoredSquareView!
    var model: ColoredSquareDataSource?
    
    // Warning: do not call before viewDidLoad()
    func updateUI() {
        squareView.setNeedsDisplay()
        hueEntry.text = "\(model[ModelKeys.hue]!)"
        sideEntry.text = "\(model[ModelKeys.sideLength])"
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
    
    func startModelListener() {
        let center = NSNotificationCenter.defaultCenter()
        let uiQueue = NSOperationQueue.mainQueue()
        
        center.addObserverForName(ModelMsgs.notificationName, object: model, queue: uiQueue) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[ModelMsgs.notificationEventKey] as? String {
                self.handleNotification(message)
            }
            else {
                assertionFailure("No message found")
            }
        }
    }
    
    func handleNotification(message: String) {
        switch message {
        case ModelMsgs.modelChangeDidFail:
            update
        case ModelMsgs.modelChangeDidSucceed:
            updateGraphicalView()
            updateTextualView()
        }
    }

    func updateGraphicalView() {
        squareView.setNeedsDisplay()
    }
    
    func updateTextualView() {
        for textField in allFields.keys {
            let modelKey = allFields[textField]!
            textField.text = "\(model[modelKey]!)"
        }
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
            model[ModelKeys.hue]! = newColor
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

