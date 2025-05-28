import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var topToasts: [ToastItem] = []
    var bottomToasts: [ToastItem] = []

    public init() {}

    public func present(
        _ edge: ToastEdge,
        _ type: ToastType,
        _ message: String,
        additionalMessage: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
    ) {
        if let imageURL {
            self._present(edge, type, message: message, additionalMessage: additionalMessage, imageUrl: imageURL)
        } else if let imageURLString {
            self._present(edge, type, message: message, additionalMessage: additionalMessage, imageUrl: URL(string: imageURLString))
        } else {
            self._present(edge, type, message: message, additionalMessage: additionalMessage, imageUrl: nil)
        }
    }

    public func present(
        _ edge: ToastEdge,
        _ type: ToastType,
        localized key: String,
        additionalMessage: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
    ) {
        let message = NSLocalizedString(key, bundle: .main, comment: "")
        self.present(
            edge,
            type,
            message,
            additionalMessage: additionalMessage,
            imageURL: imageURL,
            imageURLString: imageURLString
        )
    }

    private func _present(
        _ edge: ToastEdge,
        _ type: ToastType,
        message: String,
        additionalMessage: String?,
        imageUrl: URL?
    ) {
        Task {
            let item = ToastItem(
                type: type,
                message: message,
                additionalMessage: additionalMessage,
                imageUrl: imageUrl,
                edge: edge
            )
            switch edge{
            case .top:
                topToasts.append(item)
                try? await Task.sleep(for: .seconds(type.duration))
                topToasts.removeAll(where: { $0.id == item.id })
            case .bottom:
                bottomToasts.append(item)
                try? await Task.sleep(for: .seconds(type.duration))
                bottomToasts.removeAll(where: { $0.id == item.id })
            }
        }
    }
}
