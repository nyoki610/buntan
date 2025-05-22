import SwiftUI

struct SectionListView: ResponsiveView {
    
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
                    
                    ForEach(bookSharedData.selectedBook.sections, id: \.self) { section in
                        selectSectionButton(section)
                    }
                }
            }, paddingBottom: 100)
        }
    }
    
    @ViewBuilder
    private func selectSectionButton(_ section: Section) -> some View {
        
        Button {
            bookSharedData.selectedSectionId = section.id
            bookSharedData.arrangeContainer()
            bookSharedData.path.append(.learnSelect)
        } label: {
            HStack {
                
                Text(section.id)
                    .font(.system(size: responsiveSize(16, 20)))
                Spacer()

                Text("\(section.progressPercentage(bookSharedData.selectedBook.bookType)) %")
                    .font(.system(size: responsiveSize(14, 18)))
                    .padding(.trailing, 30)
                
                Text("\(section.cards.count) words")
                    .font(.system(size: responsiveSize(14, 18)))
                    .frame(width: responsiveSize(80, 92))
            }
            .foregroundColor(.black)
            .fontWeight(.medium)
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
        .padding(.horizontal, responsiveSize(30, 70))
        .padding(.vertical, 4)
    }
}
