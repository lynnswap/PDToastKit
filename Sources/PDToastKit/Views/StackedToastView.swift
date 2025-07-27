#if canImport(SwiftUI)
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
                    TopToastView(manager: manager, item: toast)
                        .onTapGesture { manager.topToasts.removeAll(where: {$0.id == toast.id}) }
                }
                Spacer()
            }
            .padding(.top, paddingTop)
            .animation(.bouncy, value: manager.topToasts.count)
            VStack {
                Spacer()
                ForEach(manager.bottomToasts) { toast in
                    BottomToastView(manager: manager, item: toast)
                        .onTapGesture { manager.bottomToasts.removeAll(where: {$0.id == toast.id}) }
                }
            }
            .padding(.bottom, paddingBottom)
            .animation(.bouncy, value: manager.bottomToasts.count)
        }
        .frame(maxWidth: maxWidth)
    }
}
#endif
