//
//  MealCardView.swift
//  JonathanTipton-FetchChallenge
//
//  Created by Jonathan Tipton on 10/31/23.
//

import SwiftUI

struct MealCardView: View {
    var meal: Meal
    @State private var isShowing = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
            AsyncImage(url: URL(string: meal.strMealThumb ?? ""), transaction: Transaction(animation: .spring(response: 0.5))) { phase in
                switch phase {
                case .empty:
                    EmptyView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .transition(.opacity)
                case .failure:
                    EmptyView()
                @unknown default:
                    EmptyView()
                }}

                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(colors: [.clear, .black.opacity(0.5)], startPoint: .top, endPoint: .bottom))
                        .frame(height: 200)
                    
                    Text(meal.strMeal.capitalized)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .transition(.opacity)

            }
        }
        .padding([.leading, .trailing, .bottom])
        .frame(maxWidth: .infinity)
        .onAppear(perform: {
            withAnimation(.easeIn(duration: 1)) {
                isShowing = true
            }
        })
    }
}

//#Preview {
//    MealCardView(meal: Meal.exampleMeal)
//}
