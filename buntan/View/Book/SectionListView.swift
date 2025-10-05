import SwiftUI

struct SectionListView: View {

    private let navigator: BookNavigator
    @ObservedObject private var userInput: BookUserInput
    @StateObject private var viewModel: SectionListViewViewModel
    
    init(
        navigator: BookNavigator,
        userInput: BookUserInput,
        book: Book
    ) {
        self.navigator = navigator
        self.userInput = userInput
        self._viewModel = StateObject(
            wrappedValue: SectionListViewViewModel(book: book)
        )
    }

    var body: some View {
        
        VStack {
            Header(
                navigator: navigator,
                title: (userInput.selectedGrade?.title ?? "") + "   " + viewModel.book.title
            )
            
            Spacer()
            
            listView
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.onAppearAction(userInput: userInput)
        }
    }
    
    @ViewBuilder
    private var listView: some View {
        
        ZStack {
            
            CustomScroll({
                VStack {
                    
                    ForEach(viewModel.book.sections, id: \.self) { section in
                        selectSectionButton(section: section)
                    }
                }
            }, paddingBottom: 100)
        }
    }
    
    @ViewBuilder
    private func selectSectionButton(section: Section) -> some View {
        
        Button {
            userInput.selectedSectionTitle = section.title
            
            guard let selectedBookCategory = userInput.selectedBookCategory else { return }
            
            let cardsContainer = CardsContainer(
                cards: section.cards,
                bookCategory: selectedBookCategory
            )
            navigator.push(.learnSelect(cardsContainer))
        } label: {
            HStack {
                
                Text(section.title)
                    .font(.system(size: responsiveSize(16, 20)))
                Spacer()
                
                var progressLabel: String {
                    viewModel.isFetchingUpdatedBook ? "-" : "\(section.progressPercentage(viewModel.book.bookCategory))"
                }
                
                Text("\(progressLabel) %")
                    .font(.system(size: responsiveSize(14, 18)))
                    .padding(.trailing, 30)
                
                Text("\(section.cards.count) words")
                    .font(.system(size: responsiveSize(14, 18)))
                    .frame(width: responsiveSize(80, 92))
                
                Image(systemName: "chevron.right.2")
                    
            }
            .foregroundColor(.black)
            .fontWeight(.bold)
            .padding(.horizontal, 20)
            .padding(.vertical, responsiveSize(16, 24))
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.3))
            )
        }
        // 場合分けしたい？
        .buttonStyle(.plain)
        .padding(.horizontal, responsiveSize(30, 100))
        .padding(.vertical, 4)
    }
}
