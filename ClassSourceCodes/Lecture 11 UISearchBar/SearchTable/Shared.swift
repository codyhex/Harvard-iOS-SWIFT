import Foundation
import UIKit
import MediaPlayer
import AVFoundation

// MARK: Globals
let Center = NSNotificationCenter.defaultCenter()

// MARK: Storyboard constants
struct ViewConstants {
    static let SearchTableCell = "Search Table Cell"
}

// MARK: Media
class Sound: NSObject, AVSpeechSynthesizerDelegate {
    override init() {
        // This is experimentally necessary to allow the two types of Audio to co-exist
        // without stepping on one another. They share some sort of hidden global state
        // even when the music player is not playing.
        var err: NSError? = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: &err)
        super.init()
    }
    
    private var singer = MPMusicPlayerController.applicationMusicPlayer()
    private var talker = AVSpeechSynthesizer()
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didPauseSpeechUtterance utterance: AVSpeechUtterance!) {
        println("paused: \(utterance)")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didCancelSpeechUtterance utterance: AVSpeechUtterance!) {
        println("canceled: \(utterance)")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        println("finished: \(utterance)")
    }
    
    func play(item: Listable) {
        if let song = item as? MPMediaItem {
            play(song)
        }
        else {
            say(item.listDescription)
        }
    }
    
    func say(utterance: String) {
        if singer.playbackState == MPMusicPlaybackState.Playing {
            singer.stop()
            println("Stopping singer")
        }
        var utterance = AVSpeechUtterance(string: utterance)
        utterance.rate = 0.2 // default rate is quite fast, for the blind
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1.0
        talker.speakUtterance(utterance)
    }
    
    func play(track: MPMediaItem) {
        if singer.playbackState == MPMusicPlaybackState.Playing {
            singer.stop()
        }
        singer.setQueueWithItemCollection(MPMediaItemCollection(items: [track]))
        singer.play()
    }
}

// MARK: Model Protocols
protocol SearchConstraintsDelegate: class {
    var currentFilter: String { get set }
}

protocol SearchListDataSource: SearchConstraintsDelegate {
    func valueFromSection(section: Int, atIndex index: Int) -> Listable?
    func sectionNameFromIndex(index: Int) -> String?
    func numSections() -> Int
    func numElementsInSection(section: Int) -> Int?
}

// Items in the list
protocol Listable {
    var listDescription: String { get }
}

// Allow different types of items to go in table lists and get treated equally
// 'Printable' doesn't work on MPMediaItem, which plays by different rules being an NSObject
extension String: Listable {
    var listDescription: String {
        return self
    }
}

extension MPMediaItem: Listable {
    var listDescription: String {
        return "\(self.valueForKey(MPMediaItemPropertyTitle)!) - \(self.valueForKey(MPMediaItemPropertyAlbumTitle)!)"
    }
}


// MARK: ViewController notifications
struct Notifications {
    static let AppModel = "App-wide Model"
    static let MessageKey = "Message Key"
    static let FilterDidChangeMessage = "Filter Changed"
    
}

class ObservingViewController: UIViewController {
    private var observers = [AnyObject]()
    
    func watch(notifyName: String, sourceObj: AnyObject?, actions: [String: () -> Void]) {
        let obsHandle = Center.addObserverForName(notifyName, object: sourceObj, queue: NSOperationQueue.mainQueue()) {
            [unowned self]
            (notification) in
            if let message = notification.userInfo?[Notifications.MessageKey] as? String {
                if let actionFunc = actions[message] {
                    actionFunc()
                }
                else {
                    assertionFailure("Unkonwn message: \(message)")
                }
            }
            else {
                assertionFailure("Missing message key \(Notifications.MessageKey) for \(notifyName)")
            }
        }
        observers.append(obsHandle)
    }

    func stopObservers() {
        Center.removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
        for o in observers {
            Center.removeObserver(o)
        }
    }

    deinit {
        stopObservers()
    }
}
