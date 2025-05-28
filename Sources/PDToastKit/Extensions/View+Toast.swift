import SwiftUI

extension View {
    public func stackedToast(
        manager: PDToastManager,
        paddingTop: CGFloat = 8,
        paddingBottom: CGFloat = 8
    ) -> some View {
        self.overlay(
            StackedToastView(
                manager: manager,
                paddingTop: paddingTop,
                paddingBottom: paddingBottom
            )
        )
    }
}
