/*
import SwiftUI

struct SelectModeView: View {
    
    @Binding var selectedMode: LearnMode
    
    let isBookView: Bool
    
    var body: some View {
        
        VStack {
            Text("出題形式")
                .fontWeight(.medium)
        }
        .frame(width: 280)
        .overlay(Rectangle()
            .frame(height: 1)
            .padding(.top, 30)
            .foregroundColor(.gray),
                 alignment: .top)
        
        HStack {
            
            selectModeButton(labelTextTop: "英→日",
                             labelImage: "rectangle.on.rectangle.angled",
                             labelTextBottom: "カード",
                             targetMode: .swipe)
            
            Spacer()
            
            selectModeButton(labelTextTop: "英→日",
                             labelImage: "list.bullet",
                             labelTextBottom: "4択",
                             targetMode: .select)
            
            Spacer()
            
            selectModeButton(labelTextTop: "日→英",
                             labelImage: "keyboard.fill",
                             labelTextBottom: "タイピング",
                             targetMode: .type)
        }
        .padding(.top, 20)
        .frame(width: 280)
    }
}

extension SelectModeView {
    
    @ViewBuilder
    func selectModeButton(
        labelTextTop: String,
        labelImage: String,
        labelTextBottom: String,
        targetMode: LearnMode
    ) -> some View {
        
        Button {
            selectedMode = targetMode
        } label: {
            VStack {
                Text(labelTextTop)
                    .font(.system(size: 14))
                Image(systemName: labelImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 30)
                    .foregroundColor(.gray)
                Text(labelTextBottom)
                    .font(.system(size: 12))
                    .padding(.top, 2)
            }
            .padding(5)
            .foregroundColor(.black)
            .frame(width: 80)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Orange.defaultOrange, lineWidth: selectedMode == targetMode ? 2:0)
            )
        }
    }
}

extension LearnSelectView {
    
    @ViewBuilder
    func selectButton(
        labelTop: String,
        labelTopColor: Color,
        labelBottom: String,
        image: Img,
        targetRange: LearnRange?,
        targetMode: LearnMode?
    ) -> some View {
        
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
                    .font(.system(size: 14))
                    .foregroundColor(labelTopColor)
                Image(systemName: image.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 30)
                    .foregroundColor(.gray)
                Text(labelBottom)
                    .font(.system(size: 12))
                    .padding(.top, isRangeButton ? 2 : 0)
            }
            .padding(5)
            .foregroundColor(.black)
            .frame(width: 80)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Orange.defaultOrange, lineWidth: isSelected ? 2:0)
            )
        }
    }
}

*/
