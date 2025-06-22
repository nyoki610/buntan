import SwiftUI

struct SectionListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    private let book: Book
    @Binding private var path: [ViewName]
    
    init(path: Binding<[ViewName]>, book: Book) {
        _path = path
        self.book = book
    }

    var body: some View {
        
        VStack {
            Header(path: $path,
                   title: bookSharedData.selectedGrade.title + "   " + book.title)
            
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
            bookSharedData.selectedSectionTitle = section.title

            let cardsContainer = CardsContainer(cards: section.cards, bookCategory: bookSharedData.selectedBookCategory)
            path.append(.book(.learnSelect(cardsContainer)))
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
