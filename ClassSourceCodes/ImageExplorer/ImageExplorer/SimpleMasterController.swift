import UIKit

struct Identifiers {
    static let showImage = "showDetail"
    static let newImage = "New Image"
    static let tableCell = "Plain table cell"
    static let MISSING = "Identifier was not set in StoryBoard!"
}

// ENHANCEMENT 0
extension String {
    func isWebURL() -> Bool {
        let regex = NSRegularExpression(pattern: "^https?://", options: NSRegularExpressionOptions(), error: NSErrorPointer())
        return regex?.matchesInString(self, options: NSMatchingOptions(), range: NSMakeRange(0, count(self))).count > 0
    }
    
    // "long_snake_case_name" -> "Long Snake Case Name"
    func snakeCaseToPresentable() -> String {
        let regex = NSRegularExpression(pattern: "_", options: NSRegularExpressionOptions(), error: NSErrorPointer())
        // We're going to force-unwrap because we know 'pattern' is a valid regex
        let spacesString = regex!.stringByReplacingMatchesInString(self,
            options: NSMatchingOptions(),
            range: NSMakeRange(0, count(self)),
            withTemplate: " ")
        return spacesString.capitalizedString
    }
    
    func presentableToSnakeCase() -> String {
        let regex = NSRegularExpression(pattern: " ", options: NSRegularExpressionOptions(), error: NSErrorPointer())
        // We're going to force-unwrap because we know 'pattern' is a valid regex
        let spacesString = regex!.stringByReplacingMatchesInString(self,
            options: NSMatchingOptions(),
            range: NSMakeRange(0, count(self)),
            withTemplate: "_")
        return spacesString.lowercaseString
    }
}

class SimpleMasterController: DebugTableViewController, UISplitViewControllerDelegate, TableDataReceiverDelegate {
    // This images for educational use only. 
    // credits: http://www.wallpapervortex.com/wallpaper-34947_abstract_simple_abstract.html#.VaPITpNVhBc
    // http://pichost.me/1667184/
    // http://urdu-mag.com/blog/2012/09/beautiful-sports-action-photography/
    // http://www.h3dwallpapers.com/tall-building-1672/
    var assetImages = [ "neon_vortex", "grass_patch", "speed_skating", "tall_building", "missing_example" ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // How to detect if we're on an iPad.
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // On an iPad, the master view (Table) remains on screen. 
            // 'false' means don't clear the cell that was just tapped on.
            // Keeping the selected cell highlighted lets the user know what the detail view refers to.
            self.clearsSelectionOnViewWillAppear = false
            // Don't let the Master controller fill the screen; share it nicely with the detail view. 
            // This is possible because the iPad has *regular* width, not compact.
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // A Master-Detail view is really an instance of a UISplitViewController. Our Master and Detail ViewControllers are
        // actually siblings, where the parent is a UISplitViewController.
        // Siblings cannot be connected in Interface Builder like Outlets. So we do it manually. It must be done before any
        // layout or onscreen rendering, so this is early enough.
        if let splitVC = self.splitViewController {
            splitVC.delegate = self
            // ENHANCEMENT 5
            navigationItem.leftBarButtonItem = editButtonItem()
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        }
        else {
            assertionFailure("splitViewController was not initialized")
        }
    }
    
    func insertNewObject(sender: AnyObject) {
        assetImages.insert(Identifiers.newImage, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Util.log("enter, identifier \(segue.identifier)")
        switch segue.identifier ?? Identifiers.MISSING {
        case Identifiers.showImage:
            if let indexPath = tableView.indexPathForSelectedRow(),
                let destVCNav = segue.destinationViewController as? UINavigationController,
                let detailVC = destVCNav.topViewController as? SimpleDetailController {
                    let cell = tableView.cellForRowAtIndexPath(indexPath) as! FileNameTableCell
                    cell.editor.endEditing(true)
                    let imageURI = assetImages[indexPath.row] // This must come after! Editing may have changed it
                    if imageURI.isWebURL() {
                        detailVC.title = imageURI
                        if let imageURL = NSURL(string: imageURI), imageData = NSData(contentsOfURL: imageURL) {
                            detailVC.image = UIImage(data: imageData)
                        }
                        else {
                            detailVC.image = nil
                        }
                    }
                    else {
                        detailVC.title = imageURI.presentableToSnakeCase()
                        detailVC.image = UIImage(named: imageURI)
                    }
                    // Next lines are strictly for iPad or iPhone 6+ in landscape (horizontally regular) mode
                    // This button is ignored by horizontally compact environments
                    detailVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
                    detailVC.navigationItem.leftItemsSupplementBackButton = true
            }
            else {
                assertionFailure("Unable to transition to detail view, missing index path")
            }
            
        case Identifiers.MISSING: fallthrough
        default: assertionFailure("Unknown segue ID: \(segue.identifier)")
        }
        Util.log("leave")
    }


    // MARK: - SplitView delegate
    func splitViewController(splitViewController: UISplitViewController,
        collapseSecondaryViewController secondaryViewController: UIViewController!,
        ontoPrimaryViewController primaryViewController: UIViewController!)
        -> Bool {
            Util.log("enter/leave")
            // This forces the splitView to start with the Master; in doing so, secondaryViewController is
            // deallocated and a new one is built to hold an actual image.
            return true
    }
    
    // MARK: - Table View delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        Util.log("enter")
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Util.log("enter, section \(section)")
        return assetImages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        Util.log("enter, row \(indexPath.row)")
        // The dequeue function returns the generic 'AnyObject' type, which makes for silly looking code, but a resuable table cell
        // is always safely unwrapped as a UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifiers.tableCell, forIndexPath: indexPath) as! FileNameTableCell
        // A default cell always has a textLabel so force-unwrap it; a custom cell may not
        cell.row = indexPath.row
        cell.dataSink = self
        cell.editor.text = assetImages[indexPath.row].snakeCaseToPresentable()
        // cell.imageView!.image = UIImage(named: cell.textLabel!.text!)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator // ENHANCEMENT 2
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // ENHANCEMENT 6
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            Util.log("enter")

            if editingStyle == .Delete {
                assetImages.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
    }
    
    // MARK: Table Data Receiver delegate
    func setElementAtIndex(index: Int, toValue value: String) {
        assetImages[index] = value.isWebURL() ? value : value.presentableToSnakeCase()
    }
}
