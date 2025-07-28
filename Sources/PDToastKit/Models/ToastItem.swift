import Foundation

public class ToastItem: Identifiable {
    public var id = UUID()
    public var type: ToastType
    public var message: String
    public var detail: String?
    public var imageUrl: URL?
    public var edge: ToastEdge
    public var isPaused: Bool = false

    public init(
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
