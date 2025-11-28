//
//  DeviceHelper.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation

final class DeviceHelper {
    
    static func getCurrentDeviceModel() -> String {
            var systemInfo = utsname()
            uname(&systemInfo)

            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { (id, element) in
                guard let value = element.value as? Int8, value != 0 else { return id }
                return id + String(UnicodeScalar(UInt8(value)))
            }

            return mapToDevice(identifier: identifier)
        }
    
    private static func mapToDevice(identifier: String) -> String {
            switch identifier {

            // MARK: iPhone 15 Series
            case "iPhone16,1": return "iPhone 15"
            case "iPhone16,2": return "iPhone 15 Pro"
            case "iPhone16,4": return "iPhone 15 Pro Max"

            // MARK: iPhone 14 Series
            case "iPhone14,7": return "iPhone 14"
            case "iPhone14,8": return "iPhone 14 Plus"
            case "iPhone15,2": return "iPhone 14 Pro"
            case "iPhone15,3": return "iPhone 14 Pro Max"

            // MARK: iPhone 13 Series
            case "iPhone14,4": return "iPhone 13 Mini"
            case "iPhone14,5": return "iPhone 13"
            case "iPhone14,2": return "iPhone 13 Pro"
            case "iPhone14,3": return "iPhone 13 Pro Max"

            // MARK: iPhone 12 Series
            case "iPhone13,1": return "iPhone 12 Mini"
            case "iPhone13,2": return "iPhone 12"
            case "iPhone13,3": return "iPhone 12 Pro"
            case "iPhone13,4": return "iPhone 12 Pro Max"

            // MARK: iPhone 11 Series
            case "iPhone12,1": return "iPhone 11"
            case "iPhone12,3": return "iPhone 11 Pro"
            case "iPhone12,5": return "iPhone 11 Pro Max"

            // MARK: Older Models
            case "iPhone10,6", "iPhone10,3": return "iPhone X"
            case "iPhone8,4": return "iPhone SE"
            case "iPhone12,8": return "iPhone SE (2nd Gen)"
            case "iPhone14,6": return "iPhone SE (3rd Gen)"

            // MARK: Simulator
            case "i386", "x86_64", "arm64":
                return "Simulator (\(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "Unknown"))"

            default:
                return identifier // return raw identifier if not mapped
            }
        }
}
