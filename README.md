#  TYProgressBar

Custom animating gradient progress bar. <br />


![gif](ScreenShot/TYProgressBar.gif)

How to use 
---------
```swift
let progressBar = TYProgressBar()

func setupProgressBar() {
        progressBar.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        progressBar.center = self.view.center
        self.view.addSubview(progressBar)
    }
```

Show progress 
---------
```swift
  progressBar.progress = 0.5    // between 0 to 1
  
```
