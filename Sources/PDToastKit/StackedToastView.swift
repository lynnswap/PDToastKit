import SwiftUI

struct StackedToastView: View {
    var manager: PDToastManager
    var paddingTop: CGFloat
    var paddingBottom: CGFloat

    var body: some View {
        VStack {
            ForEach(manager.toasts.filter { $0.edge == .top }) { toast in
                ToastView(type: toast.type,
                          message: toast.message,
                          additionalMessage: toast.additionalMessage,
                          imageUrl: toast.imageUrl,
                          edge: .top)
                    .onTapGesture { manager.removeToast(item: toast) }
            }

            Spacer()

            ForEach(manager.toasts.filter { $0.edge == .bottom }) { toast in
                ToastView(type: toast.type,
                          message: toast.message,
                          additionalMessage: toast.additionalMessage,
                          imageUrl: toast.imageUrl,
                          edge: .bottom)
                    .onTapGesture { manager.removeToast(item: toast) }
            }
        }
        .frame(maxWidth: 600)
        .transition(.opacity)
        .animation(.bouncy, value: manager.toasts.count)
        .padding(.top, paddingTop)
        .padding(.bottom, paddingBottom)
    }
}
