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
            switch edge{
            case .top:
                topToasts.append(item)
                await self.monitor(item: item, in: &topToasts)
            case .bottom:
                bottomToasts.append(item)
                await self.monitor(item: item, in: &bottomToasts)
            }
        }
    }

    private func monitor(item: ToastItem, in array: inout [ToastItem]) async {
        var remaining = item.type.duration
        while remaining > 0 {
            try? await Task.sleep(for: .milliseconds(100))
            if !item.isPaused {
                remaining -= 0.1
            }
        }
        array.removeAll(where: { $0.id == item.id })
    }

    func pause(_ id: UUID) {
        if let item = topToasts.first(where: { $0.id == id }) ?? bottomToasts.first(where: { $0.id == id }) {
            item.isPaused = true
        }
    }

    func resume(_ id: UUID) {
        if let item = topToasts.first(where: { $0.id == id }) ?? bottomToasts.first(where: { $0.id == id }) {
            item.isPaused = false
        }
    }
}
