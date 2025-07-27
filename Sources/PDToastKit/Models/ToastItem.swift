import Foundation

public class ToastItem: Identifiable {
    public let id = UUID()
    let type: ToastType
    let message: String
    let detail: String?
    let imageUrl: URL?
    let edge: ToastEdge
    // Remaining time until dismissal
    var remainingDuration: TimeInterval
    // Task scheduled to remove the toast
    var dismissTask: Task<Void, Never>?
    // Last time the timer was started
    var startDate: Date?

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
        self.remainingDuration = type.duration
    }
}
