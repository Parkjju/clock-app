//
//  getCurrentDateFromSimulator.swift
//  clock-app
//
//  Created by Jun on 2023/04/11.
//

import Foundation

func getCurrentDateFromSimulator(date: Date) -> Date{
    let selectedDate = date
    let tz = TimeZone(identifier: "Asia/Seoul")
    let calendar = Calendar.current
    let koreaDate = calendar.date(byAdding: .second, value: TimeZone.current.secondsFromGMT(), to: selectedDate)
    return koreaDate!
}
