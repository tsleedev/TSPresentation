# TSPresentation

A lightweight, customizable `UIPresentationController` for transparent / partial-screen modals on iOS.

Supports several transition styles (right-to-left, bottom-to-top, fade-in 등) and configurable frame sizes (full / half / radio / fixed length), with a tap-on-dimming-view to dismiss.

## Requirements

- iOS 11.0+
- Swift 5.7+

## Installation

### Swift Package Manager

Add the package dependency in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tsleedev/TSPresentation.git", from: "1.0.0")
]
```

Or in Xcode: *File → Add Packages…* → enter the URL above.

## Usage

```swift
import TSPresentation

class MyViewController: UIViewController {
    private let presentationManager = TSPresentationManager()

    func showCustomModal() {
        let modal = SomeModalViewController()
        modal.modalPresentationStyle = .custom
        modal.transitioningDelegate = presentationManager
        present(modal, animated: true)
    }
}
```

`TSPresentationManager` can be configured with transition style, frame size, and dimming color:

```swift
let manager = TSPresentationManager(
    transitionStyle: .bottomToTop,
    frameSize: .radio(0.6),
    dimColor: UIColor.black.withAlphaComponent(0.5)
)
```

## Author

tsleedev — tslee.dev@gmail.com

## License

TSPresentation is available under the MIT license. See the LICENSE file for more info.
