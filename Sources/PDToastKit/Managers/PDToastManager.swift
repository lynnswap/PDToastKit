import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var topToasts: [ToastItem] = []
    var bottomToasts: [ToastItem] = []
    private var dismissTasks: [UUID: Task<Void, Never>] = [:]

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
        Task { [weak self] in
            guard let self else { return }
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
            resumeDismissTimer(for: item)
        }
    }

    func dismiss(_ item: ToastItem) {
        switch item.edge {
        case .top:
            topToasts.removeAll { $0.id == item.id }
        case .bottom:
            bottomToasts.removeAll { $0.id == item.id }
        }
        dismissTasks[item.id]?.cancel()
        dismissTasks[item.id] = nil
    }

    func pauseDismissTimer(for item: ToastItem) {
        dismissTasks[item.id]?.cancel()
    }

    func resumeDismissTimer(for item: ToastItem) {
        dismissTasks[item.id]?.cancel()
        dismissTasks[item.id] = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .seconds(item.type.duration))
            await self.dismiss(item)
        }
    }
}
