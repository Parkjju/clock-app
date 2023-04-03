//
//  translateSoundName.swift
//  clock-app
//
//  Created by Jun on 2023/04/03.
//

import Foundation
public func translateSoundName(text: String) -> String{
    switch text{
    case "공상음":
        return "daydream"
    case "녹차":
        return "green"
    case "놀이 시간":
        return "playTime"
    case "물결":
        return "sea"
    default:
        return ""
    }
}

public func translateSoundNameToKorean(text: String) -> String{
    switch text{
    case "daydream":
        return "공상음"
    case "green":
        return "녹차"
    case "playTime":
        return "놀이 시간"
    case "sea":
        return "물결"
    default:
        return ""
    }
}
