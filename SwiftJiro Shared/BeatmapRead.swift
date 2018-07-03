
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
var nowbeatmap = [String]()
class ReadBeatMap{
    public static func readFile(filepath: String) -> Void {
        let path = NSDataAsset.init(name: NSDataAsset.Name(rawValue: filepath))
        let string = String(data: (path?.data)!, encoding: String.Encoding.utf8)//get data in asset file
        let splited = string?.components(separatedBy: "\r\n")
        title = findTag(data: splited!, tagName: "TITLE")
        subtitle = findTag(data: splited!, tagName: "SUBTITLE")
        bpm = Double(findTag(data: splited!, tagName: "BPM"))!
        wave = findTag(data: splited!, tagName: "WAVE")
        offset = Double(findTag(data: splited!, tagName: "OFFSET"))!
        level = Int(findTag(data: splited!, tagName: "LEVEL"))!
        nowbeatmap = getBeatMap(data: splited!, difficulty: "Oni")
        print(title)
        print(subtitle)
        print(bpm)
        print(wave)
        print(offset)
        print(level)
        print(nowbeatmap)
    }
    public static func findTag(data: [String], tagName: String) -> String {
        var tmp = ""
        for i in 0..<data.count {
            let tmp2 = data[i].components(separatedBy: ":")
            if tmp2[0] == tagName{
                tmp = tmp2[1]
            }
        }
        return tmp
    }//find string after tag
    public static func getBeatMap(data: [String], difficulty: String) -> [String] {
        var difficultyline = 0
        var startline = 0
        var endline = 0
        var beatmap = [String]()
        var nowline = 0
        for i in 0..<data.count {
            let tmp2 = data[i].components(separatedBy: ":")
            if tmp2[0] == "COURSE"{
                if tmp2[1] == difficulty{
                    difficultyline = i
                    break
                }
            }
        }
        for i in difficultyline..<data.count {
            if data[i] == "#START"{
                startline = i
                break
            }
        }
        for i in difficultyline..<data.count {
            if data[i] == "#END"{
                endline = i
                break
            }
        }
        for i in startline..<endline {
            nowline = i-startline
            beatmap.append(data[i])
        }
        return beatmap
    }//get beatmap
    
}
