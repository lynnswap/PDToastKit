import Foundation
import Observation

@MainActor
@Observable public class PDToastManager {
    var topToasts: [ToastItem] = []
    var bottomToasts: [ToastItem] = []
    private var tasks: [UUID: Task<Void, Never>] = [:]

    private func startTimer(for item: ToastItem) {
        tasks[item.id]?.cancel()
        tasks[item.id] = Task { [weak self] in
            try? await Task.sleep(for: .seconds(item.type.duration))
            await self?.removeToast(item)
        }
    }

    private func cancelTimer(for item: ToastItem) {
        tasks[item.id]?.cancel()
        tasks[item.id] = nil
    }

    func pause(_ item: ToastItem) {
        cancelTimer(for: item)
    }

    func resume(_ item: ToastItem) {
        startTimer(for: item)
    }

    private func removeToast(_ item: ToastItem) {
        switch item.edge {
        case .top:
            topToasts.removeAll(where: { $0.id == item.id })
        case .bottom:
            bottomToasts.removeAll(where: { $0.id == item.id })
        }
        tasks[item.id] = nil
    }

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
        startTimer(for: item)
    }
}
