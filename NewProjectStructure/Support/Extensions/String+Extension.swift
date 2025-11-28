//
//  String+Extension.swift
//  NewProjectStructure
//
//  Created by Swapnil on 26/11/25.
//

import Foundation


extension String {

    // Check if string is empty or only whitespace
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // Trim whitespaces
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // Capitalize first letter
    func capitalizedFirst() -> String {
        guard !isEmpty else { return "" }
        return prefix(1).uppercased() + dropFirst()
    }

    // Email validation
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    // Phone number validation (basic)
    var isValidPhone: Bool {
        let phoneFormat = "^[0-9]{6,15}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: self)
    }

    // Convert string to Int
    var intValue: Int? {
        return Int(self)
    }

    // Convert string to Double
    var doubleValue: Double? {
        return Double(self)
    }

    // Localized string
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    
//    var getDateFormat:String{
//        let possibleDateFormats: [String] = [
//            "yyyy-MM-dd HH:mm:ss",  // Example: 2023-10-04 15:30:00
//            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
//            "yyyy-MM-dd",           // Example: 2023-10-04
//            "MM/dd/yyyy",           // Example: 10/04/2023
//            "dd/MM/yyyy",           // Example: 04/10/2023
//            "MMM dd, yyyy",         // Example: Oct 04, 2023
//            "MMMM dd, yyyy",        // Example: October 04, 2023
//            "yyyy/MM/dd",           // Example: 2023/10/04
//            "dd.MM.yyyy",           // Example: 04.10.2023
//            "HH:mm:ss",
//            "dd MMMM yyyy",
//            "hh:mm a"
//        ]
//        
//        let dateFormatter = DateFormatter()
//        
//        for dateFormat in possibleDateFormats {
//            dateFormatter.dateFormat = dateFormat
//            if dateFormatter.date(from: self) != nil {
//                return dateFormat
//            }
//        }
//        
//        return "yyyy-MM-dd HH:mm:ss"  // Unable to detect a valid date format
//    }
//    
//    func changeDateFormat(outputFormat:String) -> String{
//        return self.changeDateFormat(strTimeOrignal: self, inputFormat: self.getDateFormat, outputFormat: outputFormat)
//    }
    
    func changeDateFormat(strTimeOrignal: String, inputFormat strInputFormat: String, outputFormat strOutputFormat: String) -> String {
        
        if strTimeOrignal.isEmpty {
            return ""
        }
        else{
            let dateFormat = DateFormatter()

            dateFormat.locale = NSLocale(localeIdentifier: "en") as Locale
            dateFormat.dateFormat = strInputFormat
            dateFormat.timeZone = TimeZone(abbreviation: "UTC")
            let date: Date? = dateFormat.date(from: strTimeOrignal)
            //dateFormat.timeZone = TimeZone.current
            dateFormat.dateFormat = strOutputFormat
            let strNewTime: String = dateFormat.string(from: date ?? Date())
  
            return strNewTime
        }
    }
    
}
