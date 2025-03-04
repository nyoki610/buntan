import SwiftUI


enum DeviceType {
    case iPhone, iPad, unknown

    static var model: DeviceType {
        let model = UIDevice.current.model
        if model.contains("iPad") {
            return .iPad
        } else if model.contains("iPhone") {
            return .iPhone
        } else {
            return .unknown
        }
    }
    
    var description: String {
        switch self {
        case .iPhone: return "iPhone"
        case .iPad: return "iPad"
        default: return "unknown"
        }
    }
}

extension EnvironmentValues {
    @Entry var deviceType: DeviceType = DeviceType.model
}

protocol ResponsiveView: View {
    var deviceType: DeviceType { get }
}

extension ResponsiveView {
    func responsiveSize(_ iPhoneFloat: CGFloat, _ iPadFloat: CGFloat) -> CGFloat {
        (deviceType == .iPhone) ? iPhoneFloat : iPadFloat
    }
    
    func responsiveScaled(_ iPhoneFloat: CGFloat, _ scale: CGFloat) -> CGFloat {
        (deviceType == .iPhone) ? iPhoneFloat : iPhoneFloat * scale
    }
}

extension View {
    func fontSize(_ size: CGFloat) -> some View {
        self.font(.system(size: size))
    }
}

