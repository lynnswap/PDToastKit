import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var topToasts: [ToastItem] = []
    var bottomToasts: [ToastItem] = []

    public init() {}

    private func scheduleDismiss(_ item: ToastItem) {
        item.startDate = Date()
        item.dismissTask = Task { [weak self, weak item] in
            guard let self, let item else { return }
            try? await Task.sleep(for: .seconds(item.remainingDuration))
            self.remove(item)
        }
    }

    private func cancelDismiss(_ item: ToastItem) {
        if let task = item.dismissTask {
            task.cancel()
            item.dismissTask = nil
            if let start = item.startDate {
                item.remainingDuration -= Date().timeIntervalSince(start)
            }
        }
    }

    func hold(_ item: ToastItem) {
        cancelDismiss(item)
    }

    func resume(_ item: ToastItem) {
        guard item.dismissTask == nil else { return }
        if item.remainingDuration <= 0 {
            remove(item)
        } else {
            scheduleDismiss(item)
        }
    }

    private func remove(_ item: ToastItem) {
        switch item.edge {
        case .top:
            topToasts.removeAll { $0.id == item.id }
        case .bottom:
            bottomToasts.removeAll { $0.id == item.id }
        }
    }

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
        scheduleDismiss(item)
    }
}
