import Foundation

public class ToastItem: Identifiable {
    public let id = UUID()
    let type: ToastType
    let message: String
    let detail: String?
    let imageUrl: URL?
    let edge: ToastEdge
    var isInteracting: Bool = false

    init(
        type: ToastType,
        message: String,
        detail: String? = nil,
        imageUrl: URL? = nil,
        edge: ToastEdge
    ) {
        self.type = type
        self.message = message
        self.detail = detail
        self.imageUrl = imageUrl
        self.edge = edge
    }
}
