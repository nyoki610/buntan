import SwiftUI

struct BookView<ViewModel: BookViewViewModelProtocol>: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    ///
//    @State var allCardsCount: Int? = TestCruds.getAllCardsCount()
//    @State var allInfomationsCount: Int? = TestCruds.getAllInfomationsCount()
    ///
    
    var body: some View {
        
        NavigationStack(path: $viewModel.navigator.path) {
        
            ZStack {
            
                VStack(spacing: 0) {
                    
                    if let todaysWordCount = viewModel.outputs.todaysWordCount {
                        headerView(todaysWordCount: todaysWordCount)
                            .padding(.top, 40)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    eachGradeView(grade: .first)
                    
                    Spacer()
                    
                    eachGradeView(grade: .preFirst)

                    Spacer()
                    
                    ///
//                    VStack {
//                        if let allCardsCount = allCardsCount {
//                            Text("allCardsCount: \(allCardsCount)")
//                        }
//                        if let allInfomationsCount = allInfomationsCount {
//                            Text("allInfomationsCount: \(allInfomationsCount)")
//                        }
//                    }
                    ///
                    
                    Spacer()
                    Spacer()
                }
            }
            .background(CustomColor.background)
            .navigationDestination(for: BookViewName.self) { viewName in
                viewName.viewForName(navigator: viewModel.navigator, userInput: viewModel.userInput)
            }
        }
    }
    
    @ViewBuilder
    private func headerView(todaysWordCount: Int) -> some View {
        
        HStack {
            VStack {
                Text("今日の")
                Text("学習単語")
            }
            .font(.system(size: responsiveSize(14, 20)))
            
            Image(systemName: "chart.bar.fill",
                  variableValue: viewModel.outputs.variableValue)
            .font(.system(size: responsiveSize(30, 40)))
            .foregroundStyle(Orange.defaultOrange)
            
            Text("\(todaysWordCount) words")
                .padding(.top, 10)
                .font(.system(size: responsiveSize(17, 24)))

            Spacer()
        }
        .fontWeight(.bold)
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func eachGradeView(grade: EikenGrade) -> some View {
        
        VStack(spacing: 0) {
            Text(grade.title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.system(size: responsiveSize(20, 28)))
                .padding(.top, 20)
                
            HStack {
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .freq)
                Spacer()
                selectBookCategoryButton(grade: grade, bookCategory: .pos)
                Spacer()
            }
            .padding(.vertical, 20)
        }
        .foregroundColor(.black)
        .background(grade.color)
        .cornerRadius(10)
        .padding(.horizontal, responsiveSize(10, 60))
    }
    
    @ViewBuilder
    private func selectBookCategoryButton(grade: EikenGrade, bookCategory: BookCategory) -> some View {
                
        Button {
            viewModel.send(.bookCategoryButtonTapped(grade: grade, category: bookCategory))
        } label: {
            HStack {
                Text(bookCategory.buttonLabel)
                    .padding(.trailing, 10)
                Image(systemName: "chevron.right.2")
            }
            .fontWeight(.heavy)
            .font(.system(size: responsiveSize(18, 24)))
            .frame(width: responsiveSize(160, 240), height: responsiveSize(50, 70))
            .background(.white)
            .cornerRadius(10)
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(
            viewModel: BookViewViewModel(
                navigator: BookNavigator(),
                userInput: BookUserInput()
            )
        )
    }
}
