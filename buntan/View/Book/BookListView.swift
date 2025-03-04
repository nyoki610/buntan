import SwiftUI

struct BookListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    var body: some View {
        VStack {
            
            Header(bookSharedData.selectedGrade.title,
                   $bookSharedData.path)
            
            CustomScroll {
                
                listView(.freq)
                
                listView(.pos)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func listView(_ bookType: BookType) -> some View {
        
        VStack {
         
            HStack {
                Spacer()
                Img.img(.flagFill, color: Orange.defaultOrange)
                Text(bookType.headerTitle)
                Spacer()
            }
            .font(.system(size: responsiveSize(16, 20)))
            .fontWeight(.bold)
            
            ForEach(bookSharedData.selectedBooks.filter { $0.bookType == bookType }, id: \.self) { book in
                VStack {
                    if let description = book.description {
                        Text(description)
                            .font(.system(size: responsiveSize(14, 20)))
                            .fontWeight(.medium)
                            .padding(.top, 4)
                    }
                    selectBookButton(bookType, book)
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    @ViewBuilder
    private func selectBookButton(_ bookType: BookType, _ book: Book) -> some View {
        
        let disabled = (book.cardsCount == 0)
        
        Button {
            bookSharedData.selectedBookDesign = book.id
            bookSharedData.path.append(.sectionList)
        } label: {
            
            ZStack {
                
                HStack {
                    Text(book.title)
                        .font(.system(size: responsiveSize(16, 20)))
                    Spacer()
                    Text("\(book.cardsCount) words")
                        .font(.system(size: responsiveSize(14, 20)))
                }
                .foregroundColor(.black.opacity(disabled ? 0.5 : 1.0))
                .fontWeight(.medium)
                
                if disabled {
                    
                    Text("準備中")
                        .foregroundColor(.gray)
                        .font(.system(size: responsiveSize(18, 24)))
                        .bold()
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, responsiveSize(20, 30))
            .background(.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.black.opacity(0.3), lineWidth: 2)
            )
        }
        .padding(.horizontal, responsiveSize(30, 70))
        .disabled(disabled)
    }
}
