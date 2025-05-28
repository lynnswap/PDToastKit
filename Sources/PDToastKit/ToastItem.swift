import Foundation

public class ToastItem: Identifiable {
    public let id = UUID()
    let type: ToastType
    let message: String
    let additionalMessage: String?
    let imageUrl: URL?
    let edge: ToastEdge

    init(
        type: ToastType,
        message: String,
        additionalMessage: String? = nil,
        imageUrl: URL? = nil,
        edge: ToastEdge
    ) {
        self.type = type
        self.message = message
        self.additionalMessage = additionalMessage
        self.imageUrl = imageUrl
        self.edge = edge
    }
}
