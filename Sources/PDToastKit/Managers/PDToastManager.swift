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
        detail: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
    ) {
        if let imageURL {
            self._present(edge, type, message: message, detail: detail, imageUrl: imageURL)
        } else if let imageURLString {
            self._present(edge, type, message: message, detail: detail, imageUrl: URL(string: imageURLString))
        } else {
            self._present(edge, type, message: message, detail: detail, imageUrl: nil)
        }
    }

    public func present(
        _ edge: ToastEdge,
        _ type: ToastType,
        localized key: LocalizedStringResource,
        detail: String? = nil,
        imageURL: URL? = nil,
        imageURLString: String? = nil
    ) {
       
        self.present(
            edge,
            type,
            String(localized:key),
            detail: detail,
            imageURL: imageURL,
            imageURLString: imageURLString
        )
    }

    private func _present(
        _ edge: ToastEdge,
        _ type: ToastType,
        message: String,
        detail: String?,
        imageUrl: URL?
    ) {
        Task {
            let item = ToastItem(
                type: type,
                message: message,
                detail: detail,
                imageUrl: imageUrl,
                edge: edge
            )
            switch edge {
            case .top:
                topToasts.append(item)
            case .bottom:
                bottomToasts.append(item)
            }
            await monitor(item: item)
        }
    }

    private func monitor(item: ToastItem) async {
        var elapsed: Double = 0
        let duration = item.type.duration
        while elapsed < duration {
            try? await Task.sleep(for: .milliseconds(100))
            if item.isInteracting {
                continue
            }
            elapsed += 0.1
        }
        removeToast(id: item.id)
    }

    func removeToast(id: UUID) {
        topToasts.removeAll(where: { $0.id == id })
        bottomToasts.removeAll(where: { $0.id == id })
    }
}
