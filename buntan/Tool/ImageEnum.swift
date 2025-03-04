import SwiftUI

enum Img: String {
    
    case arrowClockwise = "arrow.clockwise"
    case arrowRight = "arrow.right"
    case arrowshapeTurnUpBackward2 = "arrowshape.turn.up.backward.2"
    case arrowshapeTurnUpLeft = "arrowshape.turn.up.left"
    case arrowshapeTurnUpLeftFill = "arrowshape.turn.up.left.fill"
    case arrowshapeTurnUpRight = "arrowshape.turn.up.right"
    case arrowshapeTurnUpRightFill = "arrowshape.turn.up.right.fill"
    
    case bookFill = "book.fill"
    case bookmarkFill = "bookmark.fill"
    case booksVerticalFill = "books.vertical.fill"
    case character = "character"
    case chartBarFill = "chart.bar.fill"
    case checklistChecked = "checklist.checked"
    case checkmarkCircle = "checkmark.circle"
    case circle = "circle"
    case flagFill = "flag.fill"
    case gearshapeFill = "gearshape.fill"
    case handTapFill = "hand.tap.fill"
    case keyboardFill = "keyboard.fill"
    case listBullet = "list.bullet"
    case rectangleOnRectangleAngled = "rectangle.on.rectangle.angled"
    case shoeprintsFill = "shoeprints.fill"
    case shuffle = "shuffle"
    case speakerSlash = "speaker.slash"
    case speakerWave2Fill = "speaker.wave.2.fill"
    case textformatAbc = "textformat.abc"
    case textBookClosedFill = "text.book.closed.fill"
    case xmark = "xmark"
    
    static func img(_ name: Img, variableValue: Double = 1.0, size: CGFloat = 17, color: Color, resizable: Bool = false) -> some View {
        Image(systemName: name.rawValue, variableValue: variableValue)
            .font(.system(size: size))
            .foregroundColor(color)
            .bold()
    }
}
