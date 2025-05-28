#if DEBUG
import SwiftUI

struct ToastExampleView: View {
    @State private var toast = PDToastManager()
    private let thumbnailURL = URL(string: "https://avatars.githubusercontent.com/u/65545348?s=64")!

    var body: some View {
        VStack(spacing: 24) {
            Button("Show Success") {
                toast.present(.top, .success("Copied"))
            }

            Button("Show Error with Detail") {
                toast.present(
                    .top,
                    .error("Failed"),
                    additionalMessage: "Something went wrong"
                )
            }

            Button("Show Thanks with Image") {
                toast.present(
                    .bottom,
                    .thanks("Thanks"),
                    imageURL: thumbnailURL
                )
            }
        }
        .padding()
        .stackedToast(manager: toast)
    }
}

#Preview {
    ToastExampleView()
}
#endif
