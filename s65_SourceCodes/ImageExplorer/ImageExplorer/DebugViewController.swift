import UIKit

class DebugViewController: UIViewController {
    // CONTROLLER LIFECYCLE 0
    // Normally there's no need to override the constructor. If you really need to run code immediately before all
    // other lifecycle events run, you can do so here. But due to the 'required' notation of this function signature
    // in the parent class, if you must have your own init(), it must take this form.
    
    // This requirement is so that IB is guaranteed to be able to initialize a ViewController from a textual format (.xml).
    // IB does this by preparing and passing in the an NSCoder instance that knows about XML parsing.
    // We don't concern ourselves with the particulars; we just immediteley defer that job to the parent class, who
    // that already knows how to do it. After the super() call, we can run any custom code.
    required init(coder aDecoder: NSCoder) {
        Util.log("enter")
        super.init(coder: aDecoder)
        Util.log("exit \(self)")
    }

    // CONTROLLER LIFECYCLE -1
    // Subordinate views are torn down when they disappear
    deinit {
        Util.log("deinit \(self)")
    }

    // CONTROLLER LIFECYCLE 1
    // This is a very early stage of initialization, *before* outlets are connected. Essentially right after init().
    // If custom initialization is needed before outlets get connected (for example, if you had 'didSet' in an outlet property
    // that relied on some existing intializiation) that could go here. It's more convenient than hassling with the
    // required init() stuff.
    override func awakeFromNib() {
        Util.log("enter")
        super.awakeFromNib()
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE 2
    // Just after all outlets, as specified by StoryBoard, have been connected. Runs *once*.
    // Most often all the earlier lifecycle events can be ignored and initialization such as
    // instantiating and wiring up various delegate models goes here.
    override func viewDidLoad() {
        Util.log("enter")
        super.viewDidLoad()
        Util.log("exit")
    }

    // CONTROLLER LIFECYCLE 3
    // Just before the view is about to be rendered on screen. At this point, all dimensions of this view and child subviews
    // are known, so .frame calculations are possible. This is *not* the case during viewDidLoad().
    override func viewWillAppear(animated: Bool) {
        Util.log("enter")
        super.viewWillAppear(animated)
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE 4
    // Just after the view is presented to the user.
    // Perhaps in a game is where you would resume/start any animation. If animation were started in #3,
    // the user might miss a few frames, or they would run too quickly.
    override func viewDidAppear(animated: Bool) {
        Util.log("enter")
        super.viewDidAppear(animated)
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE 5
    // The user has navigated away from this view, perhaps by entering a detail view inside a NavigationController.
    // Here's a chance to save settings, or warn the user about unsaved data before letting the view actually hide.
    override func viewWillDisappear(animated: Bool) {
        Util.log("enter")
        super.viewWillDisappear(animated)
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE 6
    // The view is no longer visible. A chance to release resources that are associated with the view being visible,
    // perhaps animation-related timers, or to stop observing uI-related notifications. (But remember to resume
    // everything in the reciprocal call -- viewWillAppear())
    override func viewDidDisappear(animated: Bool) {
        Util.log("enter")
        super.viewDidDisappear(animated)
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE (MISC. A)
    // More of an internal method. Rarely necessary to insert hooks here. Called when something about the view has changed;
    // Either appearing on screen for the first time, or the orientation has changed, or the view's frame has
    // been changed manually in code. In any case, the children have to be recalculated (based on their constraints and their
    // new parent frame).
    // iOS calls setNeedsLayout() to schedule this chain of events.
    override func viewWillLayoutSubviews() {
        Util.log("enter")
        super.viewWillLayoutSubviews()
        Util.log("exit")
    }
    
    // CONTROLLER LIFECYCLE (MISC. B)
    // The other side MISC. A, just after layout completes. Now, subviews have updated frames that are in sync
    // with the new parent frame.
    override func viewDidLayoutSubviews() {
        Util.log("enter")
        super.viewDidLayoutSubviews()
        Util.log("exit")
    }
}

