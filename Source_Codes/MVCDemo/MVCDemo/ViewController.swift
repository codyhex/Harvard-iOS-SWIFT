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
    
    @IBOutlet weak var hueEntry: UITextField!
    @IBOutlet weak var sideEntry: UITextField!
    @IBOutlet weak var xEntry: UITextField!
    @IBOutlet weak var yEntry: UITextField!
    @IBOutlet weak var connectModelButton: UIButton!
    
    @IBOutlet weak var squareView: ColoredSquareView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let frame = squareView.frame
        model = ColoredSquareModel(minX: 0.0, maxX: Double(frame.width), minY: 0.0, maxY: Double(frame.height))
        
        squareView.dataSource = model
    }
    
    @IBAction func numericValueDidChange(sender: UITextField) {
        let modelKey: String = allFields[sender]!
        model[modelKey] = sender.text.toDouble()
    }
    
    var model: ColoredSquareDataSource! {
        didSet {
            startModelListener()
        }
    }
    
    // Warning: do not call before viewDidLoad()
    func updateUI() {
        squareView.setNeedsDisplay()
        hueEntry.text = "\(model[ModelKeys.hue]!)"
        sideEntry.text = "\(model[ModelKeys.sideLength]!)"
        xEntry.text = "\(model[ModelKeys.xLoc]!)"
        yEntry.text = "\(model[ModelKeys.yLoc]!)"
        let buttonTitle = squareView.dataSource == nil ? Commands.connect : Commands.disconnect
        connectModelButton.setTitle(buttonTitle, forState: .Normal)
    }
    
    override func viewDidLoad() {
        let frame = squareView.frame
        model = ColoredSquareModel(minX: 0.0, maxX: Double(frame.width), minY: 0.0, maxY: Double(frame.height))
        updateUI()
    }
    
    @IBAction func squareViewTapped(sender: UIGestureRecognizer) {
        let tapSpot = sender.locationInView(squareView)
        model[ModelKeys.xLoc]! = Double(tapSpot.x)
        model[ModelKeys.yLoc]! = Double(tapSpot.y)
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
//            update
            println("Fail")
        case ModelMsgs.modelChangeDidSucceed:
            updateGraphicalView()
            updateTextualView()
        default:
            println("default")
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
            model[ModelKeys.sideLength]! = newSide
        }
        updateUI()
    }
    
    @IBAction func xChanged(sender: UITextField) {
        if let newX = sender.text.toDouble() {
            model[ModelKeys.xLoc]! = newX
        }
        updateUI()
    }
    
    @IBAction func yChanged(sender: UITextField) {
        if let newY = sender.text.toDouble() {
            model[ModelKeys.yLoc]! = newY
        }
        updateUI()
    }
}

