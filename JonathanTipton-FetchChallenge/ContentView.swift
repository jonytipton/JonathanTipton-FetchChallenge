//
//  ContentView.swift
//  JonathanTipton-FetchChallenge
//
//  Created by Jonathan Tipton on 10/31/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if !viewModel.isDoneLoading {
                    ProgressView()
                        .task {
                            await viewModel.loadData() // fetch meal data from API
                        }
                } else {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.meals, id: \.idMeal) { meal in
                                NavigationLink{
                                    MealDetailView(meal: meal)
                                } label: {
                                    MealCardView(meal: meal)
                                }
                            }
                        }
                    }
                }
            } //ZStack
            .navigationTitle(viewModel.selectedCategory.rawValue)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                        ForEach(ViewModel.MealCategory.allCases, id: \.rawValue) { item in
                            Button(action: {
                                viewModel.selectedCategory = item }) {
                                    if viewModel.selectedCategory == item {
                                        HStack {
                                            Text(item.rawValue)
                                            Spacer()
                                            Image(systemName: "checkmark")
                                        }
                                    } else {
                                        Text(item.rawValue)
                                    }
                                }
                        }
                    }, label: {
                        Text("Category")
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
