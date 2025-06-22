import SwiftUI

extension LearnSelectView {
    
    @ViewBuilder
    var selectView: some View {
        
        VStack {
            selectRangeView
                .padding(.top, 20)
            selectModeView
                .padding(.top, 30)
        }
    }
    
    @ViewBuilder
    private var selectModeView: some View {
        
        sectionHeader("出題形式")
        
        HStack {
            
            selectButton(labelTop: "英→日",
                         labelTopColor: .black,
                         labelBottom: "カード",
                         systemName: "rectangle.on.rectangle.angled",
                         targetRange: nil,
                         targetMode: .swipe)
            
            Spacer()
            
            selectButton(labelTop: "英→日",
                         labelTopColor: .black,
                         labelBottom: "4択",
                         systemName: "list.bullet",
                         targetRange: nil,
                         targetMode: .select)
            
            Spacer()
            
            selectButton(labelTop: "日→英",
                         labelTopColor: .black,
                         labelBottom: "タイピング",
                         systemName: "keyboard.fill",
                         targetRange: nil,
                         targetMode: .type)
        }
    }
    
    @ViewBuilder
    private var selectRangeView: some View {
        
        sectionHeader("出題範囲")
        
        HStack {
            
            selectButton(labelTop: cardsContainer.notLearnedCount.string,
                         labelTopColor: .gray,
                         labelBottom: "未学習",
                         systemName: "text.book.closed.fill",
                         targetRange: .notLearned,
                         targetMode: nil)
            
            Spacer()
            
            selectButton(labelTop: cardsContainer.learningCount.string,
                         labelTopColor: RoyalBlue.semiOpaque,
                         labelBottom: "学習中",
                         systemName: "bookmark.fill",
                         targetRange: .learning,
                         targetMode: nil)
            
            Spacer()
            
            selectButton(labelTop: cardsContainer.allCount.string,
                         labelTopColor: .black,
                         labelBottom: "すべて",
                         systemName: "books.vertical.fill",
                         targetRange: .all,
                         targetMode: nil)
        }
    }
    
    @ViewBuilder
    private func sectionHeader(_ label: String) -> some View {
        
        VStack {
            Text(label)
                .fontWeight(.medium)
                .fontSize(responsiveSize(16, 20))
        }
        .frame(width: responsiveSize(280, 360))
        .overlay(Rectangle().frame(height: 1).padding(.top, 30).foregroundColor(.gray), alignment: .top)
    }
    
    @ViewBuilder
    func selectButton(
        labelTop: String,
        labelTopColor: Color,
        labelBottom: String,
        systemName: String,
        targetRange: LearnRange?,
        targetMode: LearnMode?
    ) -> some View {
        
        let disabled = (labelTop == "0")
        let isRangeButton = (targetRange != nil)
        var isSelected:Bool {
            if let targetRange = targetRange {
                return bookSharedData.selectedRange == targetRange
            }
            if let targetMode = targetMode {
                return bookSharedData.selectedMode == targetMode
            }
            return false
        }
        
        Button {
            if let targetRange = targetRange {
                bookSharedData.selectedRange = targetRange
            }
            if let targetMode = targetMode {
                bookSharedData.selectedMode = targetMode
            }
        } label: {
            VStack {
                Text(labelTop)
                    .fontSize(responsiveSize(14, 18))
                    .foregroundColor(labelTopColor)
                    .fontWeight(.bold)
                Image(systemName: systemName)
                    .resizable()
                    .fontSize(responsiveSize(16, 24))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 30)
                    .foregroundColor(.gray)
                Text(labelBottom)
                    .fontSize(responsiveSize(12, 16))
                    .padding(.top, isRangeButton ? 2 : 0)
                    .fontWeight(.medium)
                    .opacity(!disabled ? 1.0 : 0.5)
            }
            .padding(5)
            .foregroundColor(.black)
            .frame(width: responsiveSize(80, 100), height: responsiveSize(94, 120))
            .background(!disabled ? .white : .gray.opacity(0.2))
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Orange.defaultOrange, lineWidth: isSelected ? 2:0)
            )
        }
        .disabled(disabled)
    }
}
