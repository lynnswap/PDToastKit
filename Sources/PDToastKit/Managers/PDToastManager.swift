import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var topToasts: [ToastItem] = []
    var bottomToasts: [ToastItem] = []
    var tasks: [UUID: Task<Void, Never>] = [:]

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

        let task = Task { [weak self] in
            try? await Task.sleep(for: .seconds(type.duration))
            if Task.isCancelled{
                return
            }
            self?.expireToast(item.id)
        }
        tasks[item.id] = task
    }

    public func dismiss(_ id: UUID) {
        tasks[id]?.cancel()
        expireToast(id)
    }

    private func expireToast(_ id: UUID) {
        tasks.removeValue(forKey: id)
        topToasts.removeAll { $0.id == id }
        bottomToasts.removeAll { $0.id == id }
    }

    /// Cancel the scheduled dismiss task for the toast.
    func pause(_ id: UUID) {
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }

    /// Restart the dismiss task for the toast.
    func resume(_ item: ToastItem) {
        let task = Task { [weak self] in
            try? await Task.sleep(for: .seconds(item.type.duration))
            if Task.isCancelled{
                return
            }
            self?.expireToast(item.id)
        }
        tasks[item.id] = task
    }
}
