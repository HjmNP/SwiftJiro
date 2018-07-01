
//
//  BeatmapRead.swift
//  SwiftJiro
//
//  Created by 한지민 on 2018. 7. 1..
//  Copyright © 2018년 HjmNP. All rights reserved.
//

import Foundation
import Cocoa
var title = ""
var subtitle = ""
var bpm = 0.111
var wave = ""
var offset = 0.1
var songvol = ""
var sevol = ""
var demostart = ""
var scoremode = ""
var level = 0
class ReadBeatMap{
    public static func readBeatMap(filepath: String) -> Void {
        let path = NSDataAsset.init(name: NSDataAsset.Name(rawValue: filepath))
        let string = String(data: (path?.data)!, encoding: String.Encoding.utf8)
        let splited = string?.components(separatedBy: ":")
        title = findTag(data: splited!, tagName: "TITLE")
        subtitle = findTag(data: splited!, tagName: "SUBTITLE")
        bpm = Double(findTag(data: splited!, tagName: "BPM"))!
        wave = findTag(data: splited!, tagName: "WAVE")
        offset = Double(findTag(data: splited!, tagName: "OFFSET"))!
        level = Int(findTag(data: splited!, tagName: "LEVEL"))!
        print(title)
        print(subtitle)
        print(bpm)
        print(wave)
        print(offset)
        print(level)
    }
    public static func findTag(data: [String], tagName: String) -> String {
        var tmp = ""
        for i in 0..<data.count {
            if data[i] == tagName{
                tmp = data[i+1].components(separatedBy: "\r\n")[0]
                break
            }
            let tmp2 = data[i+1].components(separatedBy: "\r\n")
            if tmp2[1] == tagName{
                tmp = data[i+2].components(separatedBy: "\r\n")[0]
                break
            }
        }
        return tmp
    }
}
