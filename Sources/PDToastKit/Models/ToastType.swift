import SwiftUI

public struct ToastType {
    public var message: String
    public var iconName: String
    public var color: Color
    public var duration: Double

    public init(
        message: String,
        iconName: String,
        color: Color,
        duration: Double = 5.0
    ) {
        self.message = message
        self.iconName = iconName
        self.color = color
        self.duration = duration
    }
}

extension ToastType {
    public static func success(_ message: String) -> Self {
        Self(message: message, iconName: "checkmark.circle", color: .green)
    }

    public static func error(_ message: String) -> Self {
        Self(message: message, iconName: "xmark.circle", color: .red)
    }

    public static func warning(_ message: String) -> Self {
        Self(message: message, iconName: "exclamationmark.triangle", color: .yellow)
    }

    public static func thanks(_ message: String) -> Self {
        Self(message: message, iconName: "heart.fill", color: .pink, duration: 6.0)
    }
}
