//
//  ContentView-ViewModel.swift
//  JonathanTipton-FetchChallenge
//
//  Created by Jonathan Tipton on 11/3/23.
//

import Foundation
import SwiftUI

extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        public enum MealCategory: String, CaseIterable {
            case Beef, Chicken, Dessert, Lamb, Miscellaneous, Pasta, Pork, Seafood
        }
        
        @Published private(set) var meals: [Meal] = []
        @Published var selectedCategory: MealCategory = .Dessert {
            didSet {
                withAnimation {
                    isDoneLoading = false
                }
                // Reload List after Category selection
                Task {
                    await loadData()
                }
            }
        }
        
        var isDoneLoading = false
        
        func loadData() async {
            var urlString = ""
            switch selectedCategory {
            case .Beef:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=beef"
            case .Chicken:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=chicken"
            case .Dessert:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=dessert"
            case .Lamb:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=lamb"
            case .Miscellaneous:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=miscellaneous"
            case .Pasta:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=pasta"
            case .Pork:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=pork"
            case .Seafood:
                urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=seafood"
            }
            guard let url = URL(string: urlString) else {
                print("Invalid URL string: \(urlString)")
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let decodedResponse = try? JSONDecoder().decode(Meals.self, from: data) {
                    self.meals = decodedResponse.meals
                    // Sort meals alphabetically
                    self.meals.sort { $0.strMeal < $1.strMeal }
                    withAnimation {
                        isDoneLoading = true
                    }
                }
            } catch {
                print("Invalid data for URL: \(url)")
            }
        }
    }
}
