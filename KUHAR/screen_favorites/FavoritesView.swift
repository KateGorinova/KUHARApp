import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Избранное")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.leading, 30)
                    .padding(.top, 20)
                
                HStack {
                    NavigationLink(destination:  SavedRecipesView()) {
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemOrange).opacity(0.2))
                                .frame(width: 170, height: 200)
                                .overlay(
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 40))
                                )
                                .padding(.leading, 15)
                            Text("Мои любимые\nрецепты")
                                .font(.headline)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .padding(.top, 5)
                                .padding(.leading, 13)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.leading)
                
                Spacer()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
