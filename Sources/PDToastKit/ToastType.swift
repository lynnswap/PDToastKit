import SwiftUI

public enum ToastType {
    case success(String)
    case error(String)
    case warning(String)
    case thanks(String)

    var message: String {
        switch self {
        case .success(let message): return message
        case .warning(let message): return message
        case .error(let message): return message
        case .thanks(let message): return message
        }
    }

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle"
        case .warning: return "exclamationmark.triangle"
        case .error: return "xmark.circle"
        case .thanks: return "heart.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .warning: return .yellow
        case .error: return .red
        case .thanks: return .pink
        }
    }

    var duration: Double {
        switch self {
        case .success: return 5.0
        case .warning: return 5.0
        case .error: return 5.0
        case .thanks: return 6.0
        }
    }
}
