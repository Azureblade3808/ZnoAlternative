# KMSOrientationPatch

## Motivation

In iOS APPs, a view controller can provide which interface orientations it supports, and view controllers may have different supported interface orientations between each other.

When a view controller is presented or dismissed, the whole UI will probably rotate, letting the active view controller lay in one of its supported interface orientations.

But if a view controller is pushed or popped within a navigation controller, things get somehow different. Firstly, the active view controller is the navigation controller instead of one of the view controller in it, so the orientation of UI is determined by the navigation controller's supported interface orientation. Still, even if we have codes that bind the navigation controller's supported interface orientation with its top view controller's, UI will not rotate upon pushing or popping. Simply speaking, you will almost definitely fail to push a view controller which doesn't support current interface orientation, then expect the UI to rotate automatically.

Normally, one would be told to add codes like
````Swift
UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
````
to deal with such situations. This hack may accomplish something, but leaves unreadable codes here and there. More importantly, using it tend to lead to odd UI rotations afterwards.

So comes this Framework `KMSOrientationPatch`. 

## Usage

After importing it into your project, you can simply call
````Swift
UIDevice.attemptRotationToSupportedOrientations()
````
in Swift, or
````ObjC
[UIDevice attemptRotationToSupportedOrientations];
````
in Objective-C at any time on main thread, to let UI rotate to the closest supported orientation. 
 
You may add codes like below into your base view controller and no longer need to think about rotations.
````Swift
override
func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear(animated)
	
	UIDevice.attemptRotationToSupportedOrientations()
}
````

## Importing

* At this point, copying the file `UIDevice+Extensions.swift` into your project is sufficient for it to work.

* Or you can add the project `KMSOrientationPatch` into your workspace as a Framework project.

* At last, you can use it as a pod by adding next line into your pod file.
````
pod 'KMSOrientationPatch'
````

