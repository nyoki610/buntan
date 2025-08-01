import SwiftUI

struct BookListView: View {
    
    @State private var showDetail: Bool = false
    
    @ObservedObject private var pathHandler: BookViewPathHandler
    @ObservedObject private var userInput: BookUserInput
    private let bookList: [Book]
    
    init(pathHandler: BookViewPathHandler, userInput: BookUserInput, bookList: [Book]) {
        self.pathHandler = pathHandler
        self.userInput = userInput
        self.bookList = bookList
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Header(pathHandler: pathHandler)

                HStack {
                    Spacer()

                    Image(systemName: "flag.fill")
                        .foregroundStyle(Orange.defaultOrange)
                    
                    Text(userInput.selectedBookCategory?.headerTitle ?? "")
                    Spacer()
                }
                .font(.system(size: responsiveSize(18, 24)))
                .fontWeight(.bold)
                
                HStack {
                    Spacer()
                    Text(userInput.selectedGrade?.title ?? "")
                        .bold()
                        .font(.system(size: responsiveSize(18, 24)))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(userInput.selectedGrade?.color ?? .clear)
                .cornerRadius(10)
                .padding(.horizontal, responsiveSize(40, 120))
                .padding(.top, 4)
                .padding(.bottom, 10)
                
                listView
                    .padding(.horizontal, responsiveSize(30, 100))
                
                if userInput.selectedBookCategory == .freq {
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
            userInput.selectedBookConfig = book.config
            pathHandler.transitionScreen(to: .sectionList(book))
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
                ForEach(FrequencyBookConfiguration.allCases, id: \.self) { freqConfig in
                    detailContent(title: freqConfig.title, description: freqConfig.description)
                        .padding(.bottom, 8)
                }
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
