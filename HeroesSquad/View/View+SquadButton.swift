import SwiftUI

struct SquadButton: View {
    @State var hero: Character
    @State var isInSquad: Bool = false
    @State private var showAlert = false
    
    var onSquadToggled: ((Character) async -> Void)?

    var body: some View {
        Button(action: {
            print("initial tap: \(isInSquad)")
            if !isInSquad {
                Task {
                    isInSquad.toggle()
                    print("after toggle tap: \(isInSquad)")
                    await triggerSquadButton()
                }
            } else {
                showAlert = isInSquad ? true : false
            }
        }) {
            Text(
                isInSquad
                    ? TextContent.squadButtonFireText
                    : TextContent.squadButtonRecruitText
            )
                .font(.headline)
                .fontWeight(.semibold)
        }
        .frame(height: .large)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(isInSquad ? .clear : .redLight)
        .cornerRadius(.small)
        .shadow(color: .redHighlight, radius: .medium)
        .overlay(
            RoundedRectangle(cornerRadius: .small)
                .stroke(
                    isInSquad ? Color.redLight : .redDark,
                    style: StrokeStyle(lineWidth: .xSmall)
                )
        )
        .padding(.horizontal, .medium)
        .alert(isPresented:$showAlert) {
            Alert(
                title: Text("Are you sure you want to fire \(hero.name)?"),
                primaryButton: .destructive(Text("YES")) {
                    Task {
                        print("mesa se ayto")
                        isInSquad.toggle()
                        await triggerSquadButton()
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func triggerSquadButton() async {
        if let onSquadToggled = onSquadToggled {
            await onSquadToggled(hero)
        }
    }
}
