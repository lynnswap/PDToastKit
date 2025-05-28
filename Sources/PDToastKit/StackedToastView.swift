import SwiftUI

struct StackedToastView: View {
  var manager: PDToastManager
  var paddingTop: CGFloat
  var paddingBottom: CGFloat

  @ViewBuilder
  private func toastSection(for edge: Edge) -> some View {
    ForEach(manager.toasts.filter { $0.edge == edge }) { toast in
      ToastView(
        type: toast.type,
        message: toast.message,
        additionalMessage: toast.additionalMessage,
        imageUrl: toast.imageUrl,
        edge: edge
      )
      .onTapGesture { manager.removeToast(item: toast) }
    }
  }

  var body: some View {
    VStack {
      toastSection(for: .top)
      Spacer()
      toastSection(for: .bottom)
    }
    .frame(maxWidth: 600)
    .transition(.opacity)
    .animation(.bouncy, value: manager.toasts.count)
    .padding(.top, paddingTop)
    .padding(.bottom, paddingBottom)
  }
}
