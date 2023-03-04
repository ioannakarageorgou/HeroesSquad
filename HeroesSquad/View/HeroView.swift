import SwiftUI
import CachedAsyncImage

struct HeroView: View {
    
    @State var hero: Character

    var body: some View {
        HStack {
            CachedAsyncImage(url: hero.imageUrl, content: { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: .large, height: .large)
                    .padding(.all, .medium)
            }, placeholder: {
                Image(systemName: "photo.fill")
            })

            Text(hero.name)
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)

            Spacer()

            Image.chevronImage
                .padding(.horizontal, .medium)
                .foregroundColor(Color.greyLight)
        }
        .background(Color.greyMedium)
    }
}
