## Peng He S65 HW3

#### 1. There are two kinds notifications running around now: 
###### direct timer events, and model updates. Think of them as two separate radio stations that are broadcasting on two different frequencies. Is this cool, or confusing? How much so? In all seriousness, why not just send the **“model changed” NSNotification** directly to the custom view class **ModelBasedCellGridView**, since that’s where it really matters in this App?

It is confusing, but they are not interfering. This is a model based design. It is really bad to let the view responds for value change instead of the controller. By separating the role, we could assume that if the View gets changed but the controller remains same, there will be no big effect on our design. 

#### Is the allFields dictionary fully initialized before or after viewDidLoad? If I wrote a constructor for the ViewController (init method), could I correctly initialize allFields there? Explain.

allFields gets filled before viewDidLoad(). 
You may not write a constructor which overrides the init() because the thing it does with set sell property allFields[] and this will cause a pause on the iOS program cycle. The iOS will perform viewDidLoad() and then go back to the overrides init(). However, if we don’t re-write init(), it will happen first then the viewDidLoad()

#### Add a new computed property to the model: the area of the square. What part of the UIBible says this area calculation belongs in the model? Use this computed property to keep a constantly up-to-date readout of the rectangle’s area shown on screen.

According to the Bible, this area property should in part B: Derived data
