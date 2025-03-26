import SwiftUI

struct SearchView: View {
    @State private var recipeName: String = ""
    @State private var foundRecipes: [Recipe] = [] // Список найденных рецептов
    @State private var selectedCategory: String? = nil
    @State private var selectedDiet: String? = nil
    @State private var selectedCuisine: String? = nil
    @State private var selectedSorting: String? = nil
    @State private var isCategoryExpanded = false
    @State private var isDietExpanded = false
    @State private var isCuisineExpanded = false
    @State private var isSortingExpanded = false
    @State private var isSearching: Bool = false  // Переход на экран результатов только по кнопке

    let categories = ["Завтраки", "Закуски", "Напитки", "Основные блюда", "Паста и пицца", "Выпечка и десерты", "Заготовки", "Сэндвичи", "Ризотто", "Соусы", "Салаты", "Супы"]
    
    let diets = ["Кето-диета", "Безглютеновая диета", "Вегетарианская диета", "Веганская еда", "Безлактозная диета", "Низкокалорийная еда", "Постная еда", "Меню при диабете", "Детское меню"]
    
    let cuisines = ["Итальянская кухня", "Грузинская кухня", "Китайская кухня", "Французская кухня", "Русская кухня", "Японская кухня", "Индийская кухня", "Мексиканская кухня", "Греческая кухня", "Корейская кухня", "Турецкая кухня", "Белорусская кухня", "Кавказская кухня"]
    
    let sortingOptions = ["Название (А-Я)", "Название (Я-А)", "По времени (меньше → больше)", "По времени (больше → меньше)", "По калориям (меньше → больше)", "По калориям (больше → меньше)"]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Название (необязательно)", text: $recipeName)
                        .onChange(of: recipeName) { _ in
                            updateFoundRecipes()  // Обновляем количество рецептов при изменении текста
                        }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                .padding(.horizontal)
                .padding(.top)

                List {
                    ExpandableFilterSection(title: "Категория", options: categories, selectedOption: $selectedCategory, isExpanded: $isCategoryExpanded)
                        .onChange(of: selectedCategory) { _ in
                            updateFoundRecipes()  // Обновляем количество рецептов при изменении фильтра
                        }
                    ExpandableFilterSection(title: "Диета", options: diets, selectedOption: $selectedDiet, isExpanded: $isDietExpanded)
                        .onChange(of: selectedDiet) { _ in
                            updateFoundRecipes()  // Обновляем количество рецептов при изменении фильтра
                        }
                    ExpandableFilterSection(title: "Кухня", options: cuisines, selectedOption: $selectedCuisine, isExpanded: $isCuisineExpanded)
                        .onChange(of: selectedCuisine) { _ in
                            updateFoundRecipes()  // Обновляем количество рецептов при изменении фильтра
                        }
                    ExpandableFilterSection(title: "Сортировка", options: sortingOptions, selectedOption: $selectedSorting, isExpanded: $isSortingExpanded)
                        .onChange(of: selectedSorting) { _ in
                            updateFoundRecipes()  // Обновляем количество рецептов при изменении фильтра
                        }
                }
                .listStyle(InsetGroupedListStyle())

                // Текст с количеством найденных рецептов
                Text("Найдено \(foundRecipes.count) рецептов")
                    .padding()

                // Скрываем NavigationLink, чтобы избежать перехода на страницу результатов сразу
                NavigationLink(destination: RecipeResultsView(recipes: foundRecipes), isActive: $isSearching) {
                    EmptyView()
                }
                .hidden()

                Button(action: performSearch) {
                    Text("Поиск")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
        }
    }

    private func performSearch() {
        // Только при нажатии кнопки "Поиск" выполняем поиск
        foundRecipes = DatabaseManager.shared.fetchRecipesByFilters(
            title: recipeName,
            category: selectedCategory,
            diet: selectedDiet,
            cuisine: selectedCuisine,
            sorting: selectedSorting
        )
        isSearching = true  // Переход на страницу с результатами только после выполнения поиска
    }

    // Функция для обновления списка найденных рецептов (без выполнения поиска)
    private func updateFoundRecipes() {
        // Пока что просто обновляем количество рецептов, но не выполняем поиск
        foundRecipes = DatabaseManager.shared.fetchRecipesByFilters(
            title: recipeName,
            category: selectedCategory,
            diet: selectedDiet,
            cuisine: selectedCuisine,
            sorting: selectedSorting
        )
    }
}

// 📌 Разворачивающиеся секции фильтрации и сортировки
struct ExpandableFilterSection: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String?
    @Binding var isExpanded: Bool

    var body: some View {
        Section {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Text(selectedOption ?? title)
                        .foregroundColor(selectedOption == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            
            if isExpanded {
                ForEach(options, id: \.self) { option in
                    HStack {
                        Image(systemName: selectedOption == option ? "checkmark.square.fill" : "square")
                            .foregroundColor(selectedOption == option ? .orange : .gray)
                            .onTapGesture {
                                selectedOption = (selectedOption == option) ? nil : option
                                isExpanded = false
                            }
                        Text(option)
                    }
                }
            }
        } header: {
            Text(title)
                .font(.headline)
        }
    }
}
