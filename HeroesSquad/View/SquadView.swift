import SwiftUI
import CachedAsyncImage

struct SquadView: View {
    
    @State var hero: Character

    var body: some View {
        VStack {
            CachedAsyncImage(url: hero.imageUrl, content: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: .xLarge, height: .xLarge)
            }, placeholder: {
                Image(systemName: "photo.fill")
            })

            VStack {
                Text(hero.name)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .foregroundColor(.white)

                Spacer()
            }
            .frame(height: .large)
        }
        .frame(maxWidth: .xLarge)
    }
}
