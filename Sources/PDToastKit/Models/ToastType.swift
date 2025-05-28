import SwiftUI

public struct ToastType {
    public var iconName: String
    public var color: Color
    public var duration: Double

    public init(
        iconName: String,
        color: Color,
        duration: Double = 5.0
    ) {
        self.iconName = iconName
        self.color = color
        self.duration = duration
    }
}

extension ToastType {
    public static var success : Self {
        Self(iconName: "checkmark.circle", color: .green)
    }
    public static var error : Self {
        Self(iconName: "xmark.circle", color: .red)
    }
    public static var warning : Self {
        Self(iconName: "exclamationmark.triangle", color: .yellow)
    }
    public static var thanks : Self {
        Self(iconName: "heart.fill", color: .pink, duration: 6.0)
    }
}
