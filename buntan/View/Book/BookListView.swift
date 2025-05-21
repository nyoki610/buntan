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
            .font(.system(size: responsiveSize(16, 20)))
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
                
                _listView
//                
//                listView(.pos)
//                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private var _listView: some View {
        
        let bookList = bookSharedData.selectedBooks.filter { $0.bookType == bookSharedData.selectedBookType }
        
        VStack {
            
            ForEach(bookList, id: \.self) { book in
                VStack {
//                    if let description = book.description {
//                        Text(description)
//                            .font(.system(size: responsiveSize(14, 20)))
//                            .fontWeight(.medium)
//                            .padding(.top, 4)
//                    }
                    selectBookButton(book)
                    
                    
//                    VStack {
//                        VStack(alignment: .leading) {
//                            Text("【頻出度A】")
//                            Text("過去に正解の選択肢として出題されたことのある単語を収録")
//                        }
//                        .font(.system(size: responsiveSize(14, 20)))
//                        .padding(4)
//                        .foregroundColor(.black)
//                        .background(.white)
//                        .cornerRadius(4)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 4)
//                                .stroke(.black.opacity(0.3), lineWidth: 2)
//                        )
//                        .padding(.top, 4)
//                        
//                        HStack {
//                            Spacer()
//                            Image(systemName: "chevron.up")
//                            Text("詳細を閉じる")
//                        }
//                    }
//                    .padding(.horizontal, 40)
                }
                .padding(.vertical, 8)
            }
        }
    }
    
//    @ViewBuilder
//    private func listView(_ bookType: BookType) -> some View {
//        
//        VStack {
//         
//            HStack {
//                Spacer()
//                Img.img(.flagFill, color: Orange.defaultOrange)
//                Text(bookType.headerTitle)
//                Spacer()
//            }
//            .font(.system(size: responsiveSize(16, 20)))
//            .fontWeight(.bold)
//            
//            ForEach(bookSharedData.selectedBooks.filter { $0.bookType == bookType }, id: \.self) { book in
//                VStack {
//                    if let description = book.description {
//                        Text(description)
//                            .font(.system(size: responsiveSize(14, 20)))
//                            .fontWeight(.medium)
//                            .padding(.top, 4)
//                    }
//                    selectBookButton(bookType, book)
//                }
//                .padding(.vertical, 4)
//            }
//        }
//    }
    
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
                    
                    Image(systemName: "chevron.right.2")
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
