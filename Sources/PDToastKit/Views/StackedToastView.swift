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
                    TopToastView(item:toast)
                        .toastInteraction(for: toast, manager: manager)
                }
                Spacer()
            }
            .padding(.top, paddingTop)
            .animation(.bouncy, value: manager.topToasts.count)
            VStack {
                Spacer()
                ForEach(manager.bottomToasts) { toast in
                    BottomToastView(item:toast)
                        .toastInteraction(for: toast, manager: manager)
                }
            }
            .padding(.bottom, paddingBottom)
            .animation(.bouncy, value: manager.bottomToasts.count)
        }
        .frame(maxWidth: maxWidth)
    }
}
