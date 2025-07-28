import SwiftUI

extension View {
    func toastGestures(for toast: ToastItem, manager: PDToastManager) -> some View {
        self
            .onTapGesture {
                manager.dismiss(toast)
            }
            .onLongPressGesture(
                perform: {
                    manager.pause(toast)
                },
                onPressingChanged: { pressing in
                    if !pressing {
                        manager.resume(toast)
                    }
                }
            )
    }
}
