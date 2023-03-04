//
//  DetailHeroView.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 18/2/23.
//

import SwiftUI
import CachedAsyncImage

struct DetailHeroView: View {
    
    @State var hero: Character
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var onSquadToggled: ((Character) async -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                CachedAsyncImage(url: hero.imageUrl, content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .clipped()
                }, placeholder: {
                    Image(systemName: "photo.fill")
                })
                
                Text(hero.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                SquadButton(hero: hero, isInSquad: hero.isInSquad, onSquadToggled: onSquadToggled)
                
                Text(hero.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .background(Color.greyDark)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
    
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
            Image("Back")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            }
        }
    }
}
