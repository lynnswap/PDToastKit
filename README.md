# PDToastKit

PDToastKit is a lightweight Swift package that presents temporary toast messages in SwiftUI.

## Features

- Present toasts from the top or bottom edge
 - Success, warning, error and thanks styles
 - Create custom toast types in extensions
- Optional detail message and thumbnail
- Automatic dismissal after a short duration

## Installation

Add `PDToastKit` to your package dependencies:

```swift
.package(url: "https://github.com/lynnswap/PDToastKit", from: "0.1.3")
```

Then include `PDToastKit` as a dependency of your target.

## Usage

Create a `PDToastManager` and attach a `stackedToast` overlay:

```swift
@State private var toast = PDToastManager()

var body: some View {
    ContentView()
        .stackedToast(manager: toast)
}
```

Present a toast using the manager:

```swift
toast.present(.top, .success, "Copied")
```

Use a localization key by specifying the `localized` argument:

```swift
toast.present(.top, .success, localized: "toast_copied")
```

Create a custom toast type:

```swift
let custom = ToastType(iconName: "star", color: .blue)
toast.present(.top, custom, "Custom")
```

You can extend `ToastType` to define reusable styles:

```swift
extension ToastType {
    static var info: Self {
        Self(iconName: "info.circle", color: .blue)
    }
}

toast.present(.top, .info, "Info")
```

See `Sources/PDToastKit/Examples/Previews.swift` for more examples.

## Apps Using

<p float="left">
    <a href="https://apps.apple.com/jp/app/tweetpd/id1671411031"><img src="https://i.imgur.com/AC6eGdx.png" height="65"></a>
</p>

## License

Released under the [MIT License](LICENSE).
