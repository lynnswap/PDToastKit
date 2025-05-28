import SwiftUI

struct StackedToastView: View {
    var manager: PDToastManager
    var paddingTop: CGFloat
    var paddingBottom: CGFloat
    
    var body: some View {
        ZStack{
            VStack {
                ForEach(manager.topToasts) { toast in
                    TopToastView(item:toast)
                        .onTapGesture { manager.topToasts.removeAll(where: {$0.id == toast.id}) }
                }
                Spacer()
            }
            .padding(.top, paddingTop)
            .animation(.bouncy, value: manager.topToasts.count)
            VStack {
                Spacer()
                ForEach(manager.bottomToasts) { toast in
                    BottomToastView(item:toast)
                        .onTapGesture { manager.bottomToasts.removeAll(where: {$0.id == toast.id}) }
                }
            }
            .padding(.bottom, paddingBottom)
            .animation(.bouncy, value: manager.bottomToasts.count)
        }
        .frame(maxWidth: 600)
    }
}
struct StackedToastSectionView: View {
    var body: some View{
        
    }
}
