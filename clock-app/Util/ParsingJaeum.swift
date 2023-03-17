//
//  ParsingJaeum.swift
//  clock-app
//
//  Created by 박경준 on 2023/03/09.
//

import Foundation

func convertJamoToChosung(jamo: String) -> String {
    switch jamo.unicodeScalars.first!.value{
    case 4352: // 초성 ㄱ을 자모 ㄱ으로
        return "ㄱ"
    case 4354:
        return "ㄴ"
    case 4355:
        return "ㄷ"
    case 4357:
        return "ㄹ"
    case 4358:
        return "ㅁ"
    case 4359:
        return "ㅂ"
    case 4361:
        return "ㅅ"
    case 4363:
        return "ㅇ"
    case 4364:
        return "ㅈ"
    case 4366:
        return "ㅊ"
    case 4367:
        return "ㅋ"
    case 4368:
        return "ㅌ"
    case 4369:
        return "ㅍ"
    case 4370:
        return "ㅎ"
    default:
        return ""
    }
}
