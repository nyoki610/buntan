import SwiftUI

struct BookListView: ResponsiveView {
    
    @Environment(\.deviceType) var deviceType: DeviceType
    
    @EnvironmentObject var realmService: RealmService
    @EnvironmentObject var bookSharedData: BookSharedData
    
    @State private var showDetail: Bool = false
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Header(path: $bookSharedData.path)

                HStack {
                    Spacer()

                    Image(systemName: "flag.fill")
                        .foregroundStyle(Orange.defaultOrange)
                    
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
                .padding(.horizontal, responsiveSize(40, 120))
                .padding(.top, 4)
                .padding(.bottom, 10)
                
                listView
                    .padding(.horizontal, responsiveSize(30, 100))
                
                if bookSharedData.selectedBookType == .freq {
                    HStack {
                        Spacer()
                        detailbutton
                    }
                    .padding(.horizontal, responsiveSize(30, 100))
                    .padding(.top, 20)
                }
                
                
                
                Spacer()
            }
        }
        .background(CustomColor.background)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showDetail) {
            bookDetailView
                .presentationDetents([.medium])
        }
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

                    Image(systemName: "chevron.right.2")
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
        .disabled(disabled)
    }
    
    @ViewBuilder
    private var detailbutton: some View {
        Button {
            showDetail = true
        } label: {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: responsiveSize(18, 22)))
                Text("詳細")
                    .fontWeight(.medium)
            }
            .foregroundStyle(.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
            .background(.white)
            .cornerRadius(responsiveSize(12, 15))
            .shadow(color: .gray.opacity(0.8), radius: 2, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    private var bookDetailView: some View {
        VStack {
            
            Spacer()
            
            VStack(spacing: 0) {
                Text("過去の英検60回分")
                Text("(2004年第1回〜2023年第3回)を")
                Text("徹底分析して作成した")
                Text("オリジナル教材を収録！")
            }
            .fontWeight(.medium)
            
            Spacer()
            
            VStack(alignment: .leading) {
                detailContent(
                    title: "頻出度A",
                    description: "「正解」として出題された単語を収録"
                )
                
                detailContent(
                    title: "頻出度B",
                    description: "「複数回」出題された単語を収録"
                )
                .padding(.top, 8)
                
                detailContent(
                    title: "頻出度C",
                    description: "出題回数の少ない単語を収録"
                )
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    private func detailContent(title: String, description: String) -> some View {
        VStack(alignment: .leading) {
            Text("【\(title)】")
                .fontWeight(.bold)
                .font(.system(size: responsiveSize(18, 22)))
            Text(description)
                .padding(.leading, 20)
        }
    }
}
