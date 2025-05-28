#if DEBUG
import SwiftUI

struct ToastExampleView: View {
    @State private var toast = PDToastManager()
    private let thumbnailURL = URL(string: "https://avatars.githubusercontent.com/u/65545348?s=64")!

    var body: some View {
        List{
            Button(String("Show Success")) {
                toast.present(.top, .success("Copied"))
            }
            Button(String("Show Error with Detail")) {
                toast.present(
                    .top,
                    .error("Failed"),
                    additionalMessage: "Something went wrong"
                )
            }
            Button(String("Show Thanks with Image")) {
                toast.present(
                    .bottom,
                    .thanks("Thanks"),
                    imageURL: thumbnailURL
                )
            }
        }
        .stackedToast(manager: toast)
    }
}

#Preview {
    ToastExampleView()
}
#endif
