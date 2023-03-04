//
//  MainView.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 18/2/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var charactersViewModel = CharactersViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color.greyDark.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    if charactersViewModel.squad.count > 0 {
                        createSquadView()
                    }
                    createHeroView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("Marvel Logo")
                }
            }
            .toolbarBackground(Color.greyDark, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .withErrorHandling(error: $charactersViewModel.viewModelError)
        .onAppear(perform: {
            charactersViewModel.loadCharacters()
            charactersViewModel.getSquadMembers()
        })
        
    }
    
    func createSquadView() -> some View {
        VStack() {
            Text("My Squad")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(2)
                .foregroundColor(.white)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(charactersViewModel.squad) { hero in
                        NavigationLink(destination: DetailHeroView(hero: hero, onSquadToggled: charactersViewModel.toggleSquadFor)) {
                            SquadView(hero: hero)
                                .listRowSeparator(.hidden)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .frame(height: 120)
        }
        .padding()
    }
    
    func createHeroView() -> some View {
        List {
            ForEach(charactersViewModel.superHeroes, id: \.id) { hero in
                ZStack {
                    NavigationLink(destination: DetailHeroView(hero: hero, onSquadToggled: charactersViewModel.toggleSquadFor)) {
                    }.opacity(0)
                    HeroView(hero: hero)
                        .background(Color.greyMedium)
                        .cornerRadius(8)
                }
                .listRowBackground(Color.greyDark)
                .task {
                    // triggers pagination when reaching bottom
                    if charactersViewModel.canTriggerPagination(for: hero) {
                        await charactersViewModel.togglePagination()
                    }
                }
            }
            .listRowSeparator(.hidden)
            .background(Color.greyDark)
        }
        .listStyle(.inset)
        .onAppear(perform: {
            charactersViewModel.loadCharacters()
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
