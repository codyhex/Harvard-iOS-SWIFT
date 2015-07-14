##### PROJECT IDEA (40 pts): Estimated time: 3-5 hours, and some dreaming We need to know now what you plan to do for your final project. To be “rich enough” it must use at least 4 of the following:

- **Storing data in the device filesystem** (often via CoreData, but also directly via file URLs is possible)
- **Reading data from the network or Web**, directly via URLs or via one of the Social Media libraries
- **Storing data back onto a web server or database**
- **Capturing images**, video, or audio from the device and allowing some kind of manipulation (saving, display, playback)
- Using the CGImage toolkit to allow user edits
- **Having multiple screens** that you navigate through (via a NavigationController, a Master/Detail view, or a TabbedViewController)
- A user preferences screen that controls display preferences such as colors and font sizes
- Use of the Physics toolkit
- Use of the Accelerometer
- Use of the GPS
- Use of MapKit
- **Use of the Social Media toolkit**
- Use of the AirDrop toolkit

***

My Idea: **The Chinese Character Breaker**

The goal of doing this is helping people to learn Chinese in a new way: the meaning of each symbol that contains in a word. In order to tell people which symbol contain what meaning. We need parse the word into symbols first and this is the functionality that this App will perform. 

This App will use **Five** list points(in bold) in the Final Project requirements above.

##### The Working Flow: 

###### First Screen (Take Picture)
1. User use iPhone’s camera to take a **PRINTED** Chinese Character.
2. The App will store it at the local memory if the user want to continuously take anther one.
3. User click “done” and finish taking picture

###### Second Screen (Select & Send)
1. displays all the image that the user have taken
1. the user can navigate through the photos and select which photo will the App use to parse
3. the user click “send” and the App will send the images to a server that takes the role of analyzing the character.
4. the App will wait

###### Third Screen (Analyzing)
1. the App will display a waiting screen until it gets some parsed information back from the server

###### Fourth Screen (Display & Share)
1. Showing the parsed results in some way
2. The user now will have the choice whether of not share the results to a Social Media website.

