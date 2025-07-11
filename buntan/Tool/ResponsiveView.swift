import SwiftUI


enum DeviceType {
    
    case iPhone, iPad, unknown
    
    static func getDeviceType() -> DeviceType {
        let model = UIDevice.current.model
        if model.contains("iPad") {
            return .iPad
        } else if model.contains("iPhone") {
            return .iPhone
        } else {
            return .unknown
        }
    }
}

extension View {
    
    func responsiveSize(_ iPhoneFloat: CGFloat, _ iPadFloat: CGFloat) -> CGFloat {
        let deviceType: DeviceType = DeviceType.getDeviceType()
        return (deviceType == .iPhone) ? iPhoneFloat : iPadFloat
    }
    
    func responsiveScaled(_ iPhoneFloat: CGFloat, _ scale: CGFloat) -> CGFloat {
        let deviceType: DeviceType = DeviceType.getDeviceType()
        return (deviceType == .iPhone) ? iPhoneFloat : iPhoneFloat * scale
    }
}
