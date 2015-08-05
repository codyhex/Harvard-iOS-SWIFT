import Foundation
import MediaPlayer

// FilteredData takes an array of list items and a filtering delegate (which is just the filter string)
// When the object is subscripted, it applies the current filter to the raw data and indexes from the resulting
// filtered data. 
class FilteredData {
    let label: String
    private var rawData: [Listable]
    private var filteredData = [Listable]()
    private var lastFilter: String?
    
    weak var constraintsDelegate: SearchConstraintsDelegate?
    
    init(label: String, elements: [Listable]) {
        self.label = label
        rawData = elements
    }
    
    private var filteredResults: [Listable] {
        if let constraints = self.constraintsDelegate where constraints.currentFilter != "" {
            if constraints.currentFilter != lastFilter {
                // It's very important for performance to remember the previous filter and
                // not recalculate this array every time it's consulted. It's consulted
                // once for every item in the table.
                lastFilter = constraints.currentFilter
                filteredData = rawData.filter { (element) in
                    let elemDesc = element.listDescription.lowercaseString
                    let matchString = constraints.currentFilter.lowercaseString
                    return elemDesc.rangeOfString(matchString) != nil
                }
            }
            return filteredData
        }
        else {
            // When constraints is the empty string, 'rangeOfString' doesn't work; just don't run the filter
            return rawData
        }
    }
    
    var count: Int {
        return filteredResults.count
    }
    
    subscript(index: Int) -> Listable? {
        get {
            if index >= 0 && index < filteredResults.count {
                return filteredResults[index]
            }
            return nil
        }
    }
}


class SearchListModel: SearchListDataSource {
    lazy var filterChanged: NSNotification = NSNotification(name: Notifications.AppModel, object: self,
        userInfo: [ Notifications.MessageKey: Notifications.FilterDidChangeMessage ])

    var currentFilter: String = "" {
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(filterChanged)
        }
    }
    
    var dataValues: [ FilteredData ] = [
        FilteredData(label: "Fruits", elements: ["Orange",      "Apple", "Pear", "Banana"              ]),
        FilteredData(label: "Bugs",   elements: ["Caterpillar", "Ant",   "Bee",  "Fruitfly", "Ladybug" ]),
        FilteredData(label: "Teachers",elements: ["Van", "Alex", "Austin", "Daniel"])
    ]
    
    init() {
        for fd in dataValues {
            fd.constraintsDelegate = self
        }
    }
    
    func valueFromSection(section: Int, atIndex index: Int) -> Listable? {
        if section >= 0 && section < dataValues.count && index >= 0 && index < dataValues[section].count {
            return dataValues[section][index]
        }
        else {
            return nil
        }
    }
    
    func sectionNameFromIndex(index: Int) -> String? {
        if index >= 0 && index < dataValues.count {
            return dataValues[index].label
        }
        else {
            return nil
        }
    }
    
    func numSections() -> Int {
        return dataValues.count
    }
    
    func numElementsInSection(section: Int) -> Int? {
        if section >= 0 && section < dataValues.count {
            return dataValues[section].count
        }
        else {
            return nil
        }
    }
}

// Challenge: create one section per Album and set the title of each section to be the Album title
class SoundTrackModel: SearchListDataSource {
    private lazy var filterChanged: NSNotification = NSNotification(name: Notifications.AppModel, object: self,
        userInfo: [ Notifications.MessageKey: Notifications.FilterDidChangeMessage ])

    var currentFilter: String = "" {
        didSet {
            NSNotificationCenter.defaultCenter().postNotification(filterChanged)
        }
    }

    private lazy var soundTracks: [Listable] = {
        var tracks = [Listable]()
        
        let query = MPMediaQuery.albumsQuery()
        for collection in query.collections as! [MPMediaItemCollection] {
            for track in collection.items as! [MPMediaItem] {
                let trackTitle = track.valueForProperty(MPMediaItemPropertyTitle) as! String
                let trackType = track.valueForProperty(MPMediaItemPropertyMediaType) as! UInt
                if (trackType & MPMediaType.Music.rawValue) != 0 {
                    tracks.append(track)
                }
            }
        }
        return tracks
    }()
    
    private lazy var filteredTracks: FilteredData = {
        let filtered = FilteredData(label: "Sound Tracks", elements: self.soundTracks)
        filtered.constraintsDelegate = self
        return filtered
    }()
    
    func valueFromSection(section: Int, atIndex index: Int) -> Listable? {
        return section == 0 ? filteredTracks[index] : nil
    }
    
    func sectionNameFromIndex(index: Int) -> String? {
        return index == 0 ? filteredTracks.label : nil
    }
    
    func numSections() -> Int {
        return 1
    }
    
    func numElementsInSection(section: Int) -> Int? {
        return section == 0 ? filteredTracks.count : nil
    }
}
