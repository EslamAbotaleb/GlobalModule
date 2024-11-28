//
//  String+Extensions.swift
//  GAZT
//
//  Created by iSlam on 10/6/20.
//  Copyright © 2020 Youxel. All rights reserved.
//

import UIKit
import CryptoSwift

extension String {

    var isArabicString: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }

    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }

    func append3Points(length: Int) -> String {
        var str = self
        if str.count > length {
            var index = str.index(str.startIndex, offsetBy: length - 3)
            //            str.insert(".", at: index)
            str.insert(contentsOf: "...", at: index)
        }
        return str
    }

    func dateTimeChangeFormat(inDateFormat: String, outDateFormat: String) -> String {

        let str = self
        let inFormatter = DateFormatter()
        inFormatter.locale = Locale(identifier: "en_US_POSIX")
        inFormatter.dateFormat = inDateFormat

        let outFormatter = DateFormatter()
        if isArabic() {
            outFormatter.locale = Locale(identifier: "ar")
        } else {
            outFormatter.locale = Locale(identifier: "en")
        }
        // outFormatter.locale = Locale(identifier: "en_US_POSIX")
        outFormatter.dateFormat = outDateFormat

        let inStr = str
        let date = inFormatter.date(from: inStr) ?? Date()
        return outFormatter.string(from: date)
    }
    func convertToNextDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        return dateFormatter.string(from: tomorrow!)
    }

    func formatDate(dateString: String?) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        if let date = dateFormatter.date(from: dateString ?? "") {
            let calendar = Calendar.current
            //            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let components = calendar.dateComponents(in: TimeZone.current, from: date)

            if let extractedDate = calendar.date(from: components) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = isArabic() ?  "yyyy/MM/dd" :  "dd/MM/yyyy"
                let formattedDate = outputFormatter.string(from: extractedDate)
                debugPrint(formattedDate)
                return formattedDate
            }
        }
        return ""
    }

    func getDateFromString() -> Date? {

        let dateFormatter = DateFormatter()
        //        dateFormatter.timeZone = timeZone_UTC //TimeZone.current//
        //        dateFormatter.locale =  dateFormatterLocal_en_US
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        if let date = dateFormatter.date(from: self) {
            return dateFormatter.date(from: dateFormatter.string(from: date))//date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZ"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss zzz"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "dd/mm/yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        return nil
    }


    func getDateUseringFormat(format: String)-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone_UTC //TimeZone.current//
        dateFormatter.locale = dateFormatterLocal_en_US

        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil

    }

    func slice(from: String, to: String) -> String? {

        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}


extension String {

    func isEmptyOrWhitespace() -> Bool {

        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }

    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }

    var withoutSpecialCharacters: String {
        return self.components(separatedBy: CharacterSet.symbols).joined(separator: "")
    }

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString()}

        do {

            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension String {

    func removingLeadingSpaces() -> String {
        guard let index = firstIndex(where: { !CharacterSet(charactersIn: String($0)).isSubset(of: .whitespaces) }) else {
            return self
        }
        return String(self[index...])
    }


    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            debugPrint(error.localizedDescription)
            return nil
        }
    }

    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: UIColor? , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \((csscolor)!.toHexString()); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";


        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            debugPrint(error)
            return nil
        }
    }

    public func convertHtmlToAttributedStringWithCSSWithLimitation(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String, maxLength: Int) -> NSAttributedString? {
        var nsStr: NSAttributedString?
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            nsStr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)

            if nsStr?.length ?? 0 > maxLength {
                return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).attributedSubstring(from: NSRange(location: 0, length: maxLength))
            } else {
                return nsStr
            }

        }
        catch {
            debugPrint(error)
            return nil
        }
    }

    func aesEncrypt(_ key: String) throws -> String? {
        do {
            let keyByteArr = Array(hex: key.lowercased())
            let ivByteArr = Array(hex: Environment.loginIV)
            let passByteArr = Array(self.utf8)


            let aes = try AES(key: keyByteArr, blockMode: CBC(iv: ivByteArr), padding: .pkcs5)


            let ciphertext = try aes.encrypt(passByteArr)
            return ciphertext.toHexString()

        }catch {
            debugPrint("error \(error)")
            return "\(error.localizedDescription)"
        }

    }


    func encrypt(publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }

        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        //
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
        }

        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            debugPrint(error.debugDescription)
            return nil
        }
        return encrypt(string: self, publicKey: secKey)
    }

    func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)

        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)

        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }


    func CreateMediaURL()-> String{
        return self
        debugPrint("CreateMediaURL Old --> \(self)")
        let fManager = "/filemanager"
        let strr = self.replacingOccurrences(of: "FileManager", with: "filemanager")

        let urlWithoutIP = strr.components(separatedBy: fManager).dropFirst().joined(separator: fManager)
        var myUrl = "file-manager" + urlWithoutIP
        var baseUrl = Environment.CONTENT_Base_URL
        baseUrl = baseUrl.components(separatedBy: "ContentWebsite").dropLast().joined(separator: fManager)

        myUrl = baseUrl + myUrl
        myUrl = myUrl.replacingOccurrences(of: "filemanager", with: "FileManager")

        //        if myUrl.contains("?"){
        //            myUrl = myUrl + "&X-IBM-Client-Id=\(Environment.X_IBM_Client_Id)"
        //        }else{
        //            myUrl = myUrl + "?X-IBM-Client-Id=\(Environment.X_IBM_Client_Id)"
        //        }

        debugPrint("CreateMediaURL New -->\(myUrl)")

        return myUrl
    }

}


extension String{

    func getImageFromBase64()-> UIImage?{
        let strr = self.replacingOccurrences(of: "data:image/png;base64,", with: "")
        let imageData = Data.init(base64Encoded: strr, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image

    }

    func getImgDataFromBase64() -> Data {
        let strr = self.replacingOccurrences(of: "data:image/png;base64,", with: "")
        let imageData = Data(base64Encoded: strr,options: .ignoreUnknownCharacters)
        return (imageData! as NSData) as Data
    }

    func createImageFromText(frame: CGRect, textColor: UIColor = .white, bgColor: UIColor = .darkGreenBlue) -> UIImage? {
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = bgColor
        nameLabel.textColor = textColor
        nameLabel.font = UIFont.Scandia_Medium(ofSize: 20)
        nameLabel.text = self
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }

    func getfirst2CharactersFromName()-> String?{
        if self.isArabicString {
            return self.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!) ") + "\($1.first ?? " ")" }
        } else {
            return self.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first ?? " ")" }

        }

    }

    func initialsFromString(string: String) -> String {
        var nameComponents = string.uppercased().components(separatedBy: CharacterSet.letters.inverted)
        nameComponents.removeAll(where: {$0.isEmpty})

        let firstInitial = nameComponents.first?.first
        let lastInitial  = nameComponents.count > 1 ? nameComponents[1].first : nil
        //        let lastInitial  = nameComponents.count > 1 ? nameComponents.last?.first : nil

        var isAr: Bool?
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        predicate.evaluate(with: string)
        if predicate.evaluate(with: string) {
            isAr = true
        } else {
            isAr = false
        }

        if isAr ?? false {
            return (firstInitial != nil ? "\(firstInitial!) " : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        } else {
            return (firstInitial != nil ? "\(firstInitial!)" : "") + (lastInitial != nil ? "\(lastInitial!)" : "")
        }
    }

}

extension String {

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func size(font: UIFont, width: CGFloat) -> CGFloat {
        let attrString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        let bounds = attrString.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        return bounds.width
    }

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

}

extension String {
    func getCurrentYear() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: today)
        return year
    }


    func getCurrentDate(formatDate: String) -> String {
        let currentDate = Date()
        let currentDayDateFormatter = currentDate.getDateFormatter(dateFormat: formatDate)
        let date = currentDayDateFormatter?.string(from: currentDate)
        return date ?? ""
    }

    //    func getLastDateInCurrentYear(formatDate: String) -> String {
    //        let currentDate = Date()
    //        let currentDayDateFormatter = currentDate.getDateFormatter(dateFormat: formatDate)
    //        let date = currentDayDateFormatter?.string(from: currentDate)
    //        return date ?? ""
    //    }
}

//MARK: - Convert sttring to decimal
extension String {
    func stringToDecimal(_ value: String) -> Decimal? {
        let stringValue: String = value

        let loc = Locale(identifier: "en_GB")

        let nf = NumberFormatter()
        nf.locale = loc
        nf.maximumFractionDigits = 3
        nf.usesGroupingSeparator = true
        nf.numberStyle = .decimal

        var decValue: Decimal? = nil

        if let _ = nf.number(from: stringValue) {

            var copy = stringValue

            if let sep = loc.groupingSeparator {
                copy = copy.split(separator: Character(sep)).joined()
            }

            decValue = Decimal(string: copy, locale: loc)
        }

        return decValue.map {return $0}
    }
}

//Validate Email
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension String {
    var boolValue: Bool {
        return (self as NSString).boolValue
    }}

extension String {
    func isValidHHMM(input: String) -> Bool {
        let comps = input.components(separatedBy: ":")

        let hhComp = comps.first ?? ""
        if hhComp.count > 2 {
            return false
        }
        let hh = Int(hhComp) ?? 0
        let hhValid = (hh < 24)

        guard comps.count == 2 else {
            return hhValid
        }

        let mmComp = comps.last ?? ""
        if mmComp.count > 2 {
            return false
        }
        let mm = Int(mmComp) ?? 0
        let mmValid = (mm < 60)

        return (hhValid && mmValid)
    }
}


extension String {
    func differenceStartAndEndTime(start: String, end: String) -> String {
        let date = Date()

        Formatter.time.defaultDate = Calendar.current.startOfDay(for: Date())
        guard let startTime = Formatter.time.date(from: start),
              var endTime = Formatter.time.date(from: end) else {
            return "0"
        }
        if endTime < startTime {
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        }
        let minutes = Int(endTime.timeIntervalSince(startTime) / 60)
        debugPrint("Here Is The Hours:", minutes / 60)
        debugPrint("Here Is The Minutes:", minutes % 60)
        let minuteTime = (minutes / 60) < 10 ? "0\(minutes / 60)" : "\(minutes / 60)"
        let hourTime = (minutes % 60) < 10 ? "0\(minutes % 60)" : "\(minutes % 60)"
        return "\(hourTime):\(minuteTime)"

    }
    func getHours(start: String, end: String) -> Int {
        Formatter.time.defaultDate = Calendar.current.startOfDay(for: Date())
        guard let startTime = Formatter.time.date(from: start),
              var endTime = Formatter.time.date(from: end) else {
            return 0
        }
        if endTime < startTime {
            endTime = Calendar.current.date(byAdding: .day, value: 1, to: endTime)!
        }
        let minutes = Int(endTime.timeIntervalSince(startTime) / 60)
        debugPrint("Here Is The Hours:", minutes / 60)
        debugPrint("Here Is The Minutes:", minutes % 60)
        let hourTime = (minutes % 60)
        return hourTime

    }
}

extension String {
    public var enToFaDigits : String {
        let englishNumbers = ["0": "۰","1": "۱","2": "۲","3": "۳","4": "٤","5": "٥","6": "٧","7": "۷","8": "۸","9": "۹"]
        var txt = self
        englishNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {

    func fileName() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }

    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }

    func convertFirstCharacterInWordIntoCapital() -> String {
        let firstCharacter = self.prefix(1)
        let uppercasedFirstCharacter = firstCharacter.uppercased()
        let capitalizedWord = uppercasedFirstCharacter + (self.dropFirst())
        return capitalizedWord
    }
}

extension String {
    func getParameterName(for index: Int, in urlString: String) -> String? {
        let pattern = "([^?&=]+)=\\{\\d+\\}" // Regex pattern to find 'parameter={number}' patterns

        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsRange = NSRange(urlString.startIndex..<urlString.endIndex, in: urlString)

            let matches = regex.matches(in: urlString, options: [], range: nsRange)
            for match in matches {
                if match.numberOfRanges == 2 {
                    let placeholderRange = match.range(at: 1)
                    if let swiftRange = Range(placeholderRange, in: urlString) {
                        let parameter = String(urlString[swiftRange])
                        let fullMatch = String(urlString[Range(match.range, in: urlString)!])
                        if fullMatch.contains("{\(index)}") {
                            return parameter
                        }
                    }
                }
            }
        } catch {
            debugPrint("Regex error: \(error)")
        }
        return nil
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"

            return dateFormatter.string(from: date)
        }
        return nil
    }
}

extension String {
    var stringByRemovingWhitespaces: String {
        let components = components(separatedBy: .whitespaces)
        return components.joined(separator: "_")
    }
    func truncateText(_ text: String, maxWords: Int) -> String {
        let words = text.split(separator: " ")
        if words.count > maxWords {
            let truncatedWords = words.prefix(maxWords)
            return truncatedWords.joined(separator: " ") + "..."
        } else {
            return text
        }
    }
}
