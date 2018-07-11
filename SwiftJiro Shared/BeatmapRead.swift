
//
//  BeatmapRead.swift
//  SwiftJiro
//
//  Created by 한지민 on 2018. 7. 1..
//  Copyright © 2018년 HjmNP. All rights reserved.
//

import Foundation
#if os(OSX)
import Cocoa     
#endif
#if os(iOS)
import UIKit
#endif

// SwiftJiro Shared 라는 이름으로 보아 macOS랑 iOS 공용으로 사용할 함수를 정의한 모양인데
// 그럴거면 한개의 프로젝트 파일에 iOS랑 macOS를 같이 끼우는게 아니라
// 두개의 프로젝트 파일을 한개의 workspace파일로 묶는게 정답이야


//var title = ""            <-- 이게 스위프트야 C언어야?
//var subtitle = ""             이렇게 짜지 말고
//var bpm = 0.111               스위프트는 객체지향임을 명심하셈
//var wave = ""
//var offset = 0.1              스위프트는 다양하고 강력한 객체지향 코딩기법을 지원함.
//var songvol = ""              이런거는 클래스로 묶어 만들어야지
//var sevol = ""                이렇게 전역변수로 나열해 놓으면 비트맵을 한번에 여러개 관리할 때는 어쩔라고 그랫음..
//var demostart = ""
//var scoremode = ""
//var level = 0
//var nowbeatmap = [String]()


class Beatmap{           //"BeatmapRead" 같은 제목은 클래스 이름으로는 부적절함. 클래스가 함수와 어떻게 다른지 잘 생각해보셈.
    
    var title: String
    var subtitle: String        // 이렇게 변수들은 클래스 안에 넣어야지
    var bpm: Double
    var wave: String            // 그리고 변수들 왜 하드코딩 되어있는 컷?
    var offset: Double          // 값이 고정된거면 하드코딩 해도 되지만
    var songVol: String         // 그렇지 않은 경우는 지양하셈.
    var seVol: String
    var demoStart: String       // 사실 이렇게 값이 많으면 머리 아프니까
    var scoreMode: String       // nowBeatmap 빼고 구조체로 묶는 것도 좋은 방법임
    var level: Int
    var noteData: [String]
    
    /**
     변수 이름 몇개를 좀 바꿨음
     
     스위프트에서는 변수명을 카멜케이스로 맞추는걸 권장함.
     demostart -> demoStart
     scoremode -> scoreMode
     
     물론 원 TJA 파일에서 저렇게 표기를 했을 수도 있겠지만 TJA는 TJA 나름, 스위프트는 스위프트 나름임.
     협업할 때 중요한 거니까 명심하셈
     
     그리고 nowbeatmap 을 noteData로 바꿨어
     
     좀더 객체지향에 가깝게 하기위함. 담는 값은 기존이랑 같으니까 걱정말고
     */
    
    init() {
        title = String()            // readFile 함수에서 변수 초기화를 진행 하길래
        subtitle = String()         // init으로 교체함
        bpm = Double()
        wave = String()             // 일단 모든 변수에 매우 기본적인 값을 넣어주고
        offset = Double()           // convenience init으로 넘긴다 이렇게 하는 이유는
        songVol = String()
        seVol = String()            // 그냥 init은 실행 될 때 객체 자신이 처음으로 선언이 되는 단계라
        demoStart = String()        // 자기자신의 함수를 사용하지 못함
        scoreMode = String()
        level = Int()               // 그래서 convenience init에서 나머지를 처리한다.
        noteData = []
    }
    
    convenience init(filePath: String) {
        self.init()
        #if os(macOS)
        let path = NSDataAsset.init(name: NSDataAsset.Name(rawValue: filePath))
        #endif
        #if os(iOS)
        let path = NSDataAsset.init(name: filePath)
        #endif
        let string = String(data: (path?.data)!, encoding: String.Encoding.utf8) //get data in asset file
        let splited = string?.components(separatedBy: "\r\n")
        
//        title = findTag(data: splited!, tagName: "TITLE")               // findTag는 잘 만들었음 ㅇㅇ
//        subtitle = findTag(data: splited!, tagName: "SUBTITLE")         // 아쉬운 점이라면 tagName이라는 이름은 불필요하게 길었던 점 ("tag" 만으로도 충분함)
//        bpm = Double(findTag(data: splited!, tagName: "BPM"))!          // 그리고 파라미터를 너무 Unsafe하게 받아오는 것.
//        wave = findTag(data: splited!, tagName: "WAVE")                 // 그러고도 예외처리 안해놓은 것
//        offset = Double(findTag(data: splited!, tagName: "OFFSET"))!
//        level = Int(findTag(data: splited!, tagName: "LEVEL"))!         // "TITLE", "SUBTITLE" "LEVEL" 같은 이름들은 값이 바뀌지 않으니까
                                                                          // 이에 대응하는 enum을 만드는 것이 어땠을까 싶음
        
        title = findTag(data: splited!, tag: .title)!           // 그리고 이게 바로 위 의견에 대한 반영결과
        subtitle = findTag(data: splited!, tag: .subtitle)!     // 사실 옵셔널 처리도 해야하지만, 너가직접 하는게 좋을거 같아서 모두 강제 언랲 했음
        bpm = Double(findTag(data: splited!, tag: .bpm)!as String)!
        wave = findTag(data: splited!, tag: .wave)!             // 옵셔널은 어떻게 처리하는 것이 현명한가? 그건 스스로 알아야 하는게 커서
        offset = Double(findTag(data: splited!, tag: .offset)!as String)!         // 설명이 어렵기도 하고 ㅎ
        level = Int(findTag(data: splited!, tag: .level)!)!
        
//        nowBeatmap = getBeatMap(data: splited!, difficulty: "Oni")      // 얘도 비슷한 방식으로 수정
        
        
        noteData = getBeatMap(data: splited!, for: .oni)
    }
    
    enum Tags: String{                  // 이런 값들을 enum으로 묶어주면
        case title = "TITLE"            // 파라미터를 굉장히 Type-safe 하게 넣을 수 있지
        case subtitle = "SUBTITLE"      // 또 편리하기도 하니까.. 난 많이 애용해
        case bpm = "BPM"
        case offset = "OFFSET"          // 스위프트가 enum으로 할 수 잇는게 굉장히 강력한 편이라
        case wave = "WAVE"              // enum 다루는 법은 꼭 공부하길 바래
        case level = "LEVEL"
    }
    
    public func findTag<T>(data: [String], tag: Tags) -> T?{    // 굳이 public으로 한 이유라도 있음? static은 개쓸데 없는거라 뺐는데 public은 혹시나 해서 남겼어
        for i in data{
            let temp = i.components(separatedBy: ":")
            if temp[0] == tag.rawValue{
                if let tag = temp[1] as? T{     //여기서 'T'는 제네릭이란거야. 제네릭에 대한건 http://minsone.github.io/mac/ios/swift-generics-summary 이걸 읽어보도록 해
                    return tag      // 이미 목표하는 태그를 찾은 상태일테니, 여기서 바로 리턴을 해줘도 됨. 오히려 사이클이 줄어서 좋아
                }else{
                    return nil      // 만약 지정된 타입으로 변환에 실패했다면 nil을 리턴하게되는거지.
                }
            }
        }
        return nil                  // 설령 아무리 찾아봐도 찾는 태그를 못 찾는 상황이 생길 수도 있어. 이때도 nil을 리턴하게 돼
    }                               // 옵셔널 처리가 귀찮겠지만 그만큼 type-safe 한 코드가 얼마나 중요한지 알아야 해.
    
    
//    public static func readFile(filepath: String) -> Void {
//        let path = NSDataAsset.init(name: NSDataAsset.Name(rawValue: filepath))
//        let string = String(data: (path?.data)!, encoding: String.Encoding.utf8)//get data in asset file
//        let splited = string?.components(separatedBy: "\r\n")
//        title = findTag(data: splited!, tagName: "TITLE")
//        subtitle = findTag(data: splited!, tagName: "SUBTITLE")
//        bpm = Double(findTag(data: splited!, tagName: "BPM"))!
//        wave = findTag(data: splited!, tagName: "WAVE")
//        offset = Double(findTag(data: splited!, tagName: "OFFSET"))!
//        level = Int(findTag(data: splited!, tagName: "LEVEL"))!
//        nowbeatmap = getBeatMap(data: splited!, difficulty: "Oni")
//        print(title)
//        print(subtitle)
//        print(bpm)
//        print(wave)
//        print(offset)
//        print(level)
//        print(nowbeatmap)
//    }

//    public func findTag(data: [String], tagName: String) -> String {
//        var tmp = ""
//        for i in 0..<data.count {
//            let tmp2 = data[i].components(separatedBy: ":")
//            if tmp2[0] == tagName{
//                tmp = tmp2[1]
//            }
//        }
//        return tmp
//    }//find string after tag
    

    
    
    enum Difficulty: String{
        case easy = "Easy"
        case Normal = "Normal"
        case Hard = "Hard"
        case oni = "Oni"
        case edit = "Edit"
    }
    
    public func getBeatMap(data: [String], for level: Difficulty) -> [String] {
        var difficultyLine = Int()
        var startLine = Int()
        var endLine = Int()
        var beatmapData = [String]()
        //var nowLine = Int()     // <-- 이거 뭐임? 안 써먹던데 다른 계획이 있는거지?
        
        for i in 0..<data.count{
            let temp = data[i].components(separatedBy: ":")
            
            if temp[0] == "COURSE"{
                if temp[1] == level.rawValue{
                    difficultyLine = i
                    break
                }
            }
        }
        
        for i in difficultyLine..<data.count{
            if data[i] == "#START"{
                startLine = i
                break;
            }
            
            if data[i] == "#END"{
                endLine = i         // 아마... #END 태그는 맨 마지막에 등장하는 태그니까
                break               // #START 탐색때 같이 돌려도 되겠더라고
            }
        }
        for i in startLine..<endLine+1{
            //nowLine = i - startLine
            beatmapData.append(data[i])
        }
        
        return beatmapData
    }
    
//    public func getBeatMap(data: [String], difficulty: String) -> [String] {
//        var difficultyline = 0
//        var startline = 0
//        var endline = 0
//        var beatmap = [String]()
//        var nowline = 0
//
//        for i in 0..<data.count {
//            let tmp2 = data[i].components(separatedBy: ":")
//            if tmp2[0] == "COURSE"{
//                if tmp2[1] == difficulty{
//                    difficultyline = i
//                    break
//                }
//            }
//        }
//        for i in difficultyline..<data.count {
//            if data[i] == "#START"{
//                startline = i
//                break
//            }
//        }
//        for i in difficultyline..<data.count {
//            if data[i] == "#END"{
//                endline = i
//                break
//            }
//        }
//        for i in startline..<endline {
//            nowline = i-startline
//            beatmap.append(data[i])
//        }
//        return beatmap
//    }//get beatmap
    
}
