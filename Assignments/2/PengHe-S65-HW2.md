# Peng He S65 HW2

# 1. (5 pts) How is the Application Delegate different from all other delegates?

An application delegate is a special delegates because it triggers when the application is opened, closed or terminated with some iOS alerts. It is very important to have it supervise the application status and response to the application status it is facing.

# (10 pts) For closures that are:
a. Stored as a property in a class instance;
b. Therefore, automatically capture self of that class;
**why is it important that they explicitly capture self as weak or unowned**?

Because only by declare the closure with a capture list to be a weak or unowned reference, it is allowed to deallocated the instance when it becomes nil. The reason is that a closure stores as a property in a class and has some self.method, which catches itself, will build a **strong** connection to the instance. On the other hand, the instance holds a **strong** reference to the closure as well. They become a two-way strong connection and when not be deinit() when you assign the instance to be `nil`.

