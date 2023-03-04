//
//  GenericErrorHandling.swift
//  HeroesSquad
//
//  Created by Ioanna Karageorgou on 20/2/23.
//

import Foundation
import SwiftUI

protocol GenericErrorEnum: Error, Identifiable {
    var title: String { get }
    var errorDescription: String { get }
}

// handle errors by showing alert
struct HandleGenericErrors<T>: ViewModifier where T: GenericErrorEnum {
    @Binding var error: T?

    func body(content: Content) -> some View {
        content
            .background(
                EmptyView()
                    .alert(item: $error) { viewModelError in
                        return Alert(title: Text(viewModelError.title),
                                     message: Text(viewModelError.errorDescription),
                                     dismissButton: .default(Text("OK")))

                    }
            )
    }
}

extension View {
    func withErrorHandling<T: GenericErrorEnum>(error: Binding<T?>) -> some View {
        modifier(HandleGenericErrors(error: error))
    }
}
