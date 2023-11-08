//
//  MealDetailView.swift
//  JonathanTipton-FetchChallenge
//
//  Created by Jonathan Tipton on 10/31/23.
//

import AVKit
import SwiftUI

struct MealDetailView: View {
    @State var meal: Meal
    @State private var titleIsShowing = false
    @State private var isLoading = true
    @State private var urlString: String?
    
    var body: some View {
        // Display progress view when loading from API
        if isLoading {
            ProgressView()
                .onAppear().task {
                    await loadDetails()
                }
        }
        else {
            List {
                VStack(spacing: 0) {
                    ZStack {
                        AsyncImage(url: URL(string: meal.strMealThumb ?? "")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(.clear)
                        }
                        .frame(height: 400)
                        .clipped()
                        
                        VStack {
                            Spacer()    
                            Text(meal.strMeal)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.bottom)
                        }
                    }
                    // Display meal title in top bar when image is not visible after scroll
                    .onDisappear() {
                        titleIsShowing = true
                    }
                    .onAppear() {
                        titleIsShowing = false
                    }
                    
                    HStack {
                        HStack {
                            Image.init(systemName: "mappin")
                            Text(meal.strArea ?? "Unknown")
                        }
                        if !meal.videoURL.isEmpty {
                            Divider()
                                .padding([.leading, .trailing])
                            Link(destination: URL(string: meal.videoURL)!, label: {
                                HStack {
                                    Image.init(systemName: "video")
                                    Text("Video")
                                }
                            })
                        }
                        if !meal.recipeURL.isEmpty {
                            Divider()
                                .padding([.leading, .trailing])
                            Link(destination: URL(string: meal.recipeURL)!, label: {
                                HStack {
                                    Image.init(systemName: "safari")
                                    Text("Website")
                                }
                            })
                        }
                        
                    } //Area, Video, Website HStack
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 50)
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)) // Remove insets for hero image
                
                Section("Instructions") {
                    Text(meal.strInstructions ?? "")
                }
                
                Section("Ingredients") {
                    ForEach(meal.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                }
            }
            .navigationTitle(titleIsShowing ? meal.strMeal : "")
            .listStyle(.grouped)
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(Color.clear)
            .ignoresSafeArea(edges: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
    
    func loadDetails() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(meal.idMeal)") else {
            print("Invalid Meal URL for ID: \(meal.idMeal)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Meals.self, from: data) {
                if let detailedMeal = decodedResponse.meals.first {
                    meal = detailedMeal
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } catch {
            print("Invalid data. Error: \(error)")
        }
    }
    
}
