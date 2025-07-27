import SwiftUI

struct StackedToastView: View {
    var manager: PDToastManager
    var paddingTop: CGFloat
    var paddingBottom: CGFloat
    var maxWidth:CGFloat?
    
    var body: some View {
        ZStack{
            VStack {
                ForEach(manager.topToasts) { toast in
                    TopToastView(item: toast)
                        .onTapGesture { manager.dismiss(toast) }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in manager.pauseDismissTimer(for: toast) }
                                .onEnded { _ in manager.resumeDismissTimer(for: toast) }
                        )
                }
                Spacer()
            }
            .padding(.top, paddingTop)
            .animation(.bouncy, value: manager.topToasts.count)
            VStack {
                Spacer()
                ForEach(manager.bottomToasts) { toast in
                    BottomToastView(item: toast)
                        .onTapGesture { manager.dismiss(toast) }
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in manager.pauseDismissTimer(for: toast) }
                                .onEnded { _ in manager.resumeDismissTimer(for: toast) }
                        )
                }
            }
            .padding(.bottom, paddingBottom)
            .animation(.bouncy, value: manager.bottomToasts.count)
        }
        .frame(maxWidth: maxWidth)
    }
}
