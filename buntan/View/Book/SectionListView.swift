import SwiftUI

struct SectionListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType

    private let book: Book
    @ObservedObject private var pathHandler: PathHandler
    @ObservedObject private var userInput: BookUserInput
    
    init(pathHandler: PathHandler, userInput: BookUserInput, book: Book) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self.book = book
    }

    var body: some View {
        
        VStack {
            Header(pathHandler: pathHandler,
                   title: (userInput.selectedGrade?.title ?? "") + "   " + book.title)
            
            Spacer()
            
            listView
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var listView: some View {
        
        ZStack {
            
            CustomScroll({
                VStack {
                    
                    ForEach(book.sections, id: \.self) { section in
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
            pathHandler.transitionScreen(to: .book(.learnSelect(cardsContainer)))
        } label: {
            HStack {
                
                Text(section.title)
                    .font(.system(size: responsiveSize(16, 20)))
                Spacer()

                Text("\(section.progressPercentage(book.bookCategory)) %")
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
