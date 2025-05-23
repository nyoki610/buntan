import SwiftUI

struct BookListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    var body: some View {
        VStack {
            
            Header(path: $bookSharedData.path)

            HStack {
                Spacer()
                Img.img(.flagFill, color: Orange.defaultOrange)
                Text(bookSharedData.selectedBookType.headerTitle)
                Spacer()
            }
            .font(.system(size: responsiveSize(18, 24)))
            .fontWeight(.bold)
            
            HStack {
                Spacer()
                Text(bookSharedData.selectedGrade.title)
                    .bold()
                    .font(.system(size: responsiveSize(18, 24)))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 10)
            .background(bookSharedData.selectedGrade.color)
            .cornerRadius(10)
            .padding(.horizontal, 40)
            .padding(.top, 4)
            .padding(.bottom, 10)
            
            CustomScroll {
                
                listView
            }
            
            Spacer()
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var listView: some View {
        
        let bookList = bookSharedData.selectedBooks.filter { $0.bookType == bookSharedData.selectedBookType }
        
        VStack {
            
            ForEach(bookList, id: \.self) { book in
                VStack {

                    selectBookButton(book)
                    
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    @ViewBuilder
    private func selectBookButton(_ book: Book) -> some View {
        
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
                        .padding(.trailing, 10)
                    
                    Img.img(.chevronRight2,
                            color: .black.opacity(disabled ? 0.5 : 1.0))
                }
                .foregroundColor(.black.opacity(disabled ? 0.5 : 1.0))
                .fontWeight(.bold)
                
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
