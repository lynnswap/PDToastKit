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
    public static let success = Self(iconName: "checkmark.circle", color: .green)

    public static let error = Self(iconName: "xmark.circle", color: .red)

    public static let warning = Self(iconName: "exclamationmark.triangle", color: .yellow)

    public static let thanks = Self(iconName: "heart.fill", color: .pink, duration: 6.0)
}
