//
//  ContentView.swift
//  Fampay
//
//  Created by Yash Somkuwar on 08/02/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = CardGroupsViewModel()
    @State private var isRefreshing = false

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
            } else {
                ScrollView {
                    ForEach(viewModel.cardGroups) { cardGroup in
                        CardGroupView(cardGroup: cardGroup)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20) // Add padding at the top for refreshing indicator
                    .gesture(DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 && !isRefreshing {
                                isRefreshing = true
                                viewModel.fetchData()
                            }
                        }
                        .onEnded { _ in
                            isRefreshing = false
                        }
                    )
                }
            }
        }
        .overlay(
            isRefreshing ? ProgressView()
                .padding(.top, 10)
                .frame(maxWidth: .infinity, alignment: .top) : nil
        )
        .onAppear {
            viewModel.fetchData()
        }
        .onChange(of: viewModel.cardGroups) { _ in
            viewModel.error = nil
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
