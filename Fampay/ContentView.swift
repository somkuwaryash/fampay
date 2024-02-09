//
//  ContentView.swift
//  Fampay
//
//  Created by Yash Somkuwar on 08/02/24.
//

import SwiftUI

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
                }
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
        .onAppear {
            viewModel.fetchData() // Fetch data when the view appears
        }
    }
}


#Preview {
    ContentView()
}


