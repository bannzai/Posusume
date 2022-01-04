//
//  String+Romaji.swift
//  SPAJAM2020Final
//
//  Created by Yutaro Muta on 2020/11/08.
//

import Foundation

extension String {
    /// ローマ字に変換
    func convertToRomaji() -> String {
        print("ローマ字に変換するよ : \(self)")

        let inputText = self as NSString
        let outputText = NSMutableString()
        var range: CFRange = CFRangeMake(0, inputText.length)
        let locale: CFLocale = CFLocaleCopyCurrent()
        let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, locale)
        var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
        while tokenType.rawValue != 0 {
            range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
            let latin: CFTypeRef = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription)
            let romaji = latin as! NSString
            outputText.append(romaji as String)
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return outputText as String
    }
}
