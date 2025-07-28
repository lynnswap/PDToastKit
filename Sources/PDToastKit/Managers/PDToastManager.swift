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

        let edge = item.edge
        let task = Task { [weak self] in
            try? await Task.sleep(for: .seconds(type.duration))
            if Task.isCancelled{
                return
            }
            self?.expireToast(item.id, edge: edge)
        }
        tasks[item.id] = task
    }

    public func dismiss(_ id: UUID) {
        tasks[id]?.cancel()
        expireToast(id)
    }

    private func expireToast(_ id: UUID, edge: ToastEdge? = nil) {
        tasks.removeValue(forKey: id)

        func remove(from edge: ToastEdge) {
            switch edge {
            case .top:
                topToasts.removeAll { $0.id == id }
            case .bottom:
                bottomToasts.removeAll { $0.id == id }
            }
        }

        if let edge {
            remove(from: edge)
            return
        }

        if topToasts.contains(where: { $0.id == id }) {
            remove(from: .top)
        } else if bottomToasts.contains(where: { $0.id == id }) {
            remove(from: .bottom)
        }
    }

    /// Cancel the scheduled dismiss task for the toast.
    func pause(_ item: ToastItem) {
        item.isPaused = true
        let id = item.id
        tasks[id]?.cancel()
        tasks.removeValue(forKey: id)
    }

    /// Restart the dismiss task for the toast.
    func resume(_ item: ToastItem) {
        if !item.isPaused{
            return
        }
        item.isPaused = false
        let edge = item.edge
        let task = Task { [weak self] in
            try? await Task.sleep(for: .seconds(item.type.duration))
            if Task.isCancelled{
                return
            }
            self?.expireToast(item.id, edge: edge)
        }
        tasks[item.id] = task
    }
}
