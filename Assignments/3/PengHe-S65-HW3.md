## Peng He S65 HW3

#### 1. There are two kinds notifications running around now: 
###### direct timer events, and model updates. Think of them as two separate radio stations that are broadcasting on two different frequencies. Is this cool, or confusing? How much so? In all seriousness, why not just send the **“model changed” NSNotification** directly to the custom view class **ModelBasedCellGridView**, since that’s where it really matters in this App?

It is confusing, but they are not interfering. This is a model based design. It is really bad to let the view responds for value change instead of the controller. By separating the role, we could assume that if the View gets changed but the controller remains same, there will be no big effect on our design. 
