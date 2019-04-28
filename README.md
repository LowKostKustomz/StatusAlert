![Author StatusAlert](https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/StatusAlert/StatusAlertHeader.png)

<p align="center">
<a><img alt="Swift" src="https://img.shields.io/badge/Swift-3.2+-F57C00.svg?style=flat" /></a>
<a><img alt="Objective-C" src="https://img.shields.io/badge/Objective--C-supported-1976D2.svg?style=flat" /></a>
<a href="https://github.com/LowKostKustomz/StatusAlert/wiki"><img alt="Wiki" src="https://img.shields.io/badge/Wiki-available-lightgrey.svg?style=flat" /></a>
<a href="https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/LICENSE"><img alt="License" src="https://img.shields.io/cocoapods/l/StatusAlert.svg?style=flat&label=License" /></a>
<a><img alt="Platform" src="https://img.shields.io/cocoapods/p/StatusAlert.svg?style=flat&label=Platform" /></a>
</p>
<p align="center">
<b>Dependency managers</b>
</p>

<p align="center">
<a href="http://cocoapods.org/pods/StatusAlert"><img alt="CocoaPods" src="https://img.shields.io/cocoapods/v/StatusAlert.svg?style=flat&label=CocoaPods&colorB=d32f2f" /></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage" src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" /></a>
<a href="https://swiftpkgs.ng.bluemix.net/package/LowKostKustomz/StatusAlert"><img alt="SwiftPackageManager" src="https://img.shields.io/badge/Swift_Package_Manager-compatible-F57C00.svg?style=flat" /></a>
<br />
</p>


<p align="center">
	<strong><a href="#features"> Features </a></strong> |
	<strong><a href="#installation"> Installation </a></strong> |
	<strong><a href="#usage"> Usage </a></strong> |
	<strong><a href="#customization"> Customization </a></strong>
</p>

StatusAlert is an iOS framework that displays status alerts similar to Apple's system self-hiding alerts. It is well suited for notifying user without interrupting user flow in iOS-like way.

It looks very similar to the alerts displayed in Podcasts, Apple Music and News apps.
![System StatusAlert](https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/Assets/iPhonesWithSystemAlerts.png)


## Features

* System-like look and feel
* Reduce transparency mode support
* VoiceOver support
* Safe Areas support
* Universal (iPhone & iPad)
* Objective-C support

## Requirements

* Xcode 9.0 or later
* iOS 9.0 or later
* Swift 3.2 or later

## Installation

### CocoaPods

To install StatusAlert using [CocoaPods](http://cocoapods.org), add the following line to your `Podfile`:

```ruby
pod 'StatusAlert', '~> 1.1.1'
```

### Carthage

To install StatusAlert using [Carthage](https://github.com/Carthage/Carthage), add the following line to your `Cartfile`:

```ruby
github "LowKostKustomz/StatusAlert" ~> 1.1.1
```

### Swift Package Manager

To install StatusAlert using [Swift Package Manager](https://github.com/apple/swift-package-manager) add this to your dependencies in a `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/LowKostKustomz/StatusAlert.git", .exact("1.1.1"))
]
```

### Manual installation

You can also add this project:
 * as git submodule
 * simply download and copy source files to your project

### Objective-C integration

StatusAlert is fully compatible with Objective-C. To import it to your project just add the following line:

```objectiveс
@import StatusAlert;
```

## Demo

Demo application is included in the `StatusAlert` workspace. To run it clone the repo.

![Demo StatusAlert](https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/Assets/iPhonesWithStatusAlert.png)

## Usage

```swift
// Importing framework
import StatusAlert

// Creating StatusAlert instance
let statusAlert = StatusAlert()
statusAlert.image = UIImage(named: "Some image name")
statusAlert.title = "StatusAlert title"
statusAlert.message = "Message to show beyond title"
statusAlert.canBePickedOrDismissed = isUserInteractionAllowed

// Presenting created instance
statusAlert.showInKeyWindow()
```
> All the alert components (`image`, `title`, `message`) are optional, but at least one should be present. Otherwise `show()` method will be ignored.
>
> **IMPORTANT**
>  > The alert must be presented only from the main thread, otherwise application will crash with an appropriate error.

## Customization

> [Wiki](https://github.com/LowKostKustomz/StatusAlert/wiki) with more content and examples available

### Different configurations

Present alert with any set of image, title and message

### Vertical position

Display alert anywhere you want, either on the top, in the center or at the bottom of the view, and with any offset.

### Appearance

You can customize a single alert's appearance via the `StatusAlert`'s `appearance` property or for all alerts at once with `StatusAlert.Appearance`'s `common` property

```swift
var titleFont: UIFont
var messageFont: UIFont
var tintColor: UIColor
var backgroundColor: UIColor
var blurStyle: UIBlurEffect.Style
```

### Dismissal

Alert will hide itself after 2 seconds timeout.

You can change alert showing duration by setting `alertShowingDuration` property. You also can set `canBePickedOrDismissed` property to `true`. After that you will be able to dismiss the alert manually by tapping it and delay dismissal by long tapping the alert.

## Apps Using _StatusAlert_

[BitxfyAppStoreLink]: https://bitxfy.com

<p align="center">
<a href="https://bitxfy.com">
<img src="https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/Assets/BitxfyIcon.png" align="center" width="40">
</a>
<br>
<strong><a href="https://bitxfy.com">
Bitxfy
</strong>
</p>

[![BitxfyScreenShot](https://raw.githubusercontent.com/LowKostKustomz/StatusAlert/master/Assets/BitxfyStatusAlert.png)][BitxfyAppstoreLink]

> Feel free to submit pull request if you are using this framework in your apps.

## Author

[FrameworksRepo]: https://github.com/LowKostKustomz/Frameworks

[![Author ActionsList](https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/StatusAlert/StatusAlertAuthor.png)][FrameworksRepo]

<p align="center">
<a href="https://twitter.com/LowKostKustomz"><img alt="https://twitter.com/LowKostKustomz" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Twitter.png" width="80"/></a>
<a href="https://www.instagram.com/lowkostkustomz/"><img alt="https://www.instagram.com/lowkostkustomz/" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Instagram.png" width="80"/></a>
<a href="https://stackoverflow.com/users/9076809/lowkostkustomz"><img alt="https://stackoverflow.com/users/9076809/lowkostkustomz" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/StackOverflow.png" width="80"/></a>
<a href="https://www.linkedin.com/in/yehor-miroshnychenko"><img alt="https://www.linkedin.com/in/yehor-miroshnychenko" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/LinkedIn.png" width="80"/></a>
<a href="mierosh@gmail.com"><img alt="mierosh@gmail.com" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Email.png" width="80"/></a>
<a href="https://github.com/LowKostKustomz/Frameworks"><img alt="https://github.com/LowKostKustomz/Frameworks" src="https://assets.gitlab-static.net/ZEBSTER/FrameworksAssets/raw/master/Socials/Portfolio.png" width="80"/></a>
</p>

## License

> The MIT License (MIT)
>
> Copyright (c) 2017-2018 LowKostKustomz <mierosh@gmail.com>
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
> THE SOFTWARE.
