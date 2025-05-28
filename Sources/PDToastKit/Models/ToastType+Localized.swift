import SwiftUI

extension ToastType {
    public static func success(localized key: LocalizedStringResource) -> Self {
        .success(String(localized: key))
    }
    public static func warning(localized key: LocalizedStringResource) -> Self {
        .warning(String(localized: key))
    }
    public static func error(localized key: LocalizedStringResource) -> Self {
        .error(String(localized: key))
    }
    public static func thanks(localized key: LocalizedStringResource) -> Self {
        .thanks(String(localized: key))
    }
}
