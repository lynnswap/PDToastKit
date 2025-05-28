# PDToastKit

PDToastKit is a lightweight Swift package that presents temporary toast messages in SwiftUI.

## Features

- Present toasts from the top or bottom edge
 - Success, warning, error and thanks styles
 - Create custom toast types in extensions
- Optional additional message and thumbnail
- Automatic dismissal after a short duration

## Installation

Add `PDToastKit` to your package dependencies:

```swift
.package(url: "https://github.com/your/PDToastKit.git", from: "0.1.0")
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

## License

Released under the [MIT License](LICENSE).
