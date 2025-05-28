import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var toasts: [ToastItem] = []

    public init() {}

    public func present(
        _ edge: ToastEdge,
        _ type: ToastType,
        additionalMessage: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
    ) {
        if let imageURL {
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: imageURL)
        } else if let imageURLString {
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: URL(string: imageURLString))
        } else {
            self.innerPresent(edge, type, additionalMessage: additionalMessage, imageUrl: nil)
        }
    }

    private func innerPresent(
        _ edge: ToastEdge,
        _ type: ToastType,
        additionalMessage: String?,
        imageUrl: URL?
    ) {
        Task {
            let item = ToastItem(
                type: type,
                message: type.message,
                additionalMessage: additionalMessage,
                imageUrl: imageUrl,
                edge: edge
            )
            toasts.append(item)
            try? await Task.sleep(for: .seconds(type.duration))
            self.removeToast(item: item)
        }
    }

    func removeToast(item: ToastItem) {
        toasts.removeAll(where: { $0.id == item.id })
    }
}
