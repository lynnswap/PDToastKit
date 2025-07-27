#if canImport(SwiftUI)
import SwiftUI

struct ToastTapGesture: UIGestureRecognizerRepresentable {
    var onEnded: () -> Void

    class Coordinator: NSObject {
        var onEnded: () -> Void
        init(onEnded: @escaping () -> Void) { self.onEnded = onEnded }
        @objc func tapped() { onEnded() }
    }

    func makeCoordinator() -> Coordinator { Coordinator(onEnded: onEnded) }

    func makeUIGestureRecognizer(context: Context) -> UITapGestureRecognizer {
        UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
    }

    func updateUIGestureRecognizer(_ uiGestureRecognizer: UITapGestureRecognizer, context: Context) {}
}

struct ToastLongPressGesture: UIGestureRecognizerRepresentable {
    var minimumDuration: Double = 0.5
    var onStart: () -> Void
    var onEnd: () -> Void

    class Coordinator: NSObject {
        var onStart: () -> Void
        var onEnd: () -> Void
        init(onStart: @escaping () -> Void, onEnd: @escaping () -> Void) {
            self.onStart = onStart
            self.onEnd = onEnd
        }
        @objc func handle(_ gesture: UILongPressGestureRecognizer) {
            switch gesture.state {
            case .began: onStart()
            case .ended, .cancelled, .failed: onEnd()
            default: break
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(onStart: onStart, onEnd: onEnd) }

    func makeUIGestureRecognizer(context: Context) -> UILongPressGestureRecognizer {
        let g = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handle(_:)))
        g.minimumPressDuration = minimumDuration
        return g
    }

    func updateUIGestureRecognizer(_ uiGestureRecognizer: UILongPressGestureRecognizer, context: Context) {}
}

struct ToastPanGesture: UIGestureRecognizerRepresentable {
    var onStart: () -> Void
    var onEnd: () -> Void

    class Coordinator: NSObject {
        var onStart: () -> Void
        var onEnd: () -> Void
        init(onStart: @escaping () -> Void, onEnd: @escaping () -> Void) {
            self.onStart = onStart
            self.onEnd = onEnd
        }
        @objc func handle(_ gesture: UIPanGestureRecognizer) {
            switch gesture.state {
            case .began, .changed: onStart()
            case .ended, .cancelled, .failed: onEnd()
            default: break
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(onStart: onStart, onEnd: onEnd) }

    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handle(_:)))
    }

    func updateUIGestureRecognizer(_ uiGestureRecognizer: UIPanGestureRecognizer, context: Context) {}
}

extension View {
    func toastInteraction(for item: ToastItem, manager: PDToastManager) -> some View {
        self
            .overlay(ToastTapGesture { manager.removeToast(id: item.id) })
            .overlay(ToastPanGesture(onStart: { item.isInteracting = true }, onEnd: { item.isInteracting = false }))
            .overlay(ToastLongPressGesture(minimumDuration: 0.3, onStart: { item.isInteracting = true }, onEnd: { item.isInteracting = false }))
    }
}
#endif
