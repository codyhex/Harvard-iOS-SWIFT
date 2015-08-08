//
//  ViewController.swift
//  SearchTable
//
//  Created by Daniel Bromberg on 7/26/15.
//  Copyright (c) 2015 S65. All rights reserved.
//

import UIKit


class SearchViewController: ObservingViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    private var models: [SearchListDataSource] = [ SoundTrackModel(), SearchListModel() ]
    private var sound = Sound()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var model: SearchListDataSource! {
        didSet {
            updateUI()
        }
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        model.currentFilter = searchText
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func modelChanged(sender: UISegmentedControl) {
        model = models[sender.selectedSegmentIndex]
    }
    
    @IBOutlet weak var searchTableView: UITableView! // datasource & delegate is set in StoryBoard
    
    func updateUI() {
        searchBar.text = model.currentFilter
        searchTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for m in models {
            watch(Notifications.AppModel, sourceObj: m, actions: [Notifications.FilterDidChangeMessage: updateUI])
        
        }
        model = models[0]
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchBar.resignFirstResponder()
        sound.play(model.valueFromSection(indexPath.section, atIndex: indexPath.row)!)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.numSections()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = searchTableView.dequeueReusableCellWithIdentifier(ViewConstants.SearchTableCell) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: ViewConstants.SearchTableCell)
        }
        
        cell!.textLabel!.text = model.valueFromSection(indexPath.section, atIndex: indexPath.row)?.listDescription
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numRows = model.numElementsInSection(section) {
            return numRows
        }
        else {
            NSLog("Unexpected section request: \(section)")
            return 0
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.sectionNameFromIndex(section)
    }
}

