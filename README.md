# Navigation Drawer
[![Version](https://img.shields.io/cocoapods/v/NavigationDrawer.svg?style=flat-square)](http://cocoapods.org/pods/NavigationDrawer) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage) [![License](https://img.shields.io/cocoapods/l/NavigationDrawer.svg?style=flat-square)](http://cocoapods.org/pods/NavigationDrawer) [![Platform](https://img.shields.io/cocoapods/p/NavigationDrawer.svg?style=flat-square)](http://cocoapods.org/pods/NavigationDrawer)

## Overview
Navigation Drawer is a simplified sliding menu control written in swift.
Look into project example to see it in action!
### Preview Samples
| BaseViewController | SlideViewController |  
| --- | --- |
| Button Pressed | Button Pressed |
| ![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/clicked-menu.gif?raw=true) | ![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/close-menu-clicked.gif?raw=true) | 
| Gesture | Gesture|
| ![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/dragged-open.gif?raw=true) | ![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/dragged-close.gif?raw=true) | 

## Requirements
- Xcode 9.
- iOS 9 or higher.

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```ruby
pod 'NavigationDrawer'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Make Things Ready In Story Board
1. Create a BaseViewController and add Navigation controller on it. Set Bar Button item on the view controller. Attatch this UIViewController to `BaseViewController.swift` ![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/setting-view-controller.png?raw=true)
2. Create a SlidingViewController and add **Action Segue**[kind: Present Modally, identifer:showSlidingMenu] from Bar Button item of `BaseViewController` to `SlidingViewController`. (PS. identifer name can be anything, just match them in swift.)
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/setting-sliding-controller.png?raw=true)
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/add-segue.png?raw=true)
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/set-segue.gif?raw=true)

3. In SlidingViewCotroller add a Close Button with view Constrains as
```
topConstrain - As View's Top Constrain
trailingConstrain - As View's Trailing Constrain
bottomConstrain - As View's Bottom Constrain
widthConstrain - As View's width Constrain with a multipler of 0.2
```
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/setting-close-button.png?raw=true)

### Some Codes in Swift (The most fun part)
1. On `BaseViewController.swift`, import **NavigationDrawer**. Create an object of **Interactor** in your `BaseViewController` add two IBActions `homeButtonPressed(_ sender: UIBarButtonItem)` and `edgePanGesture(sender: UIScreenEdgePanGestureRecognizer)`
``` swift
class ViewController: UIViewController {

//1.
let interactor = Interactor()

override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view, typically from a nib.
}

//2.
@IBAction func homeButtonPressed(_ sender: UIBarButtonItem) {
performSegue(withIdentifier: "showSlidingMenu", sender: nil)
}

//3. Add a Pan Gesture to slide the menu from Certain Direction
@IBAction func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
let translation = sender.translation(in: view)

let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Right)

MenuHelper.mapGestureStateToInteractor(
gestureState: sender.state,
progress: progress,
interactor: interactor){
self.performSegue(withIdentifier: "showSlidingMenu", sender: nil)
}
}

//4. Prepare for segue
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
if let destinationViewController = segue.destination as? SlidingViewController {
destinationViewController.transitioningDelegate = self
destinationViewController.interactor = self.interactor
}
}
}
```
2. Extend the `UIViewControllerTransitioningDelegate` in your BaseViewController and add following functions.
``` swift
extension ViewController: UIViewControllerTransitioningDelegate {

func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
return PresentMenuAnimator()
}

func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
return DismissMenuAnimator()
}

func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
return interactor.hasStarted ? interactor : nil
}

func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
return interactor.hasStarted ? interactor : nil
}
}
```

3. Create a `SlidingView.swift` and a variable of interactor that will be passed from the `BaseViewController`. [Import NavigationDrawer]
``` swift 
class SlidingViewController: UIViewController{

var interactor:Interactor? = nil

override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view, typically from a nib.
}

//Handle Gesture
@IBAction func handleGesture(sender: UIPanGestureRecognizer) {
let translation = sender.translation(in: view)

let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)

MenuHelper.mapGestureStateToInteractor(
gestureState: sender.state,
progress: progress,
interactor: interactor){
self.dismiss(animated: true, completion: nil)
}
}

@IBAction func closeBtnPressed(_ sender: Any) {
dismiss(animated: true, completion: nil)
}
}
```

### Back To StoryBoard
Now Hook up the `@IBAction` to StoryBoard.
1. On `BaseViewController`
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/view-set-up.gif?raw=true)
2. On `SlidingViewControll`
![](https://github.com/asisadh/NavigationDrawerSwift/blob/master/Images/gif/sliding-set-up.gif?raw=true)

Credits:
https://www.thorntech.com/2016/03/ios-tutorial-make-interactive-slide-menu-swift/

License
----
MIT


**Free Software, Hell Yeah!**
