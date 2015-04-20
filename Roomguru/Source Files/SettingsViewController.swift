//
//  SettingsViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    weak var aView: SettingsView?
    private let viewModel = SettingsViewModel(items: [
        SettingItem(NSLocalizedString("Manage calendars", comment: ""), .noneType, "manageCalendars")
    ])
    
    private var header: SettingsCollectionViewHeader?
    
    // MARK: View life cycle
    
    override func loadView() {
        aView = loadViewWithClass(SettingsView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setuptCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Sign out", comment: ""), style: .Plain, target: self, action: Selector("didTapSignOutButton:"))
    }
}

// MARK: UICollectionViewFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 54)
    }
}

// MARK: UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SettingsCell.reuseIdentifier, forIndexPath: indexPath) as! SettingsCell
        
        let item = viewModel[indexPath.row]
        
        cell.textLabel.text = item.title
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if self.header == nil {
            self.header = (collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SettingsCollectionViewHeader.reuseIdentifier, forIndexPath: indexPath) as! SettingsCollectionViewHeader)
        }
        return header!
    }
}

//MARK: UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewModel[indexPath.row].performActionWithTarget(self)
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return viewModel[indexPath.row].selectable()
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)!.backgroundColor = UIColor(white: 0.73, alpha: 1)
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.cellForItemAtIndexPath(indexPath)!.backgroundColor = UIColor.whiteColor()
    }
}

//MARK: UIControl

extension SettingsViewController {

    func didTapSignOutButton(sender: UIBarButtonItem) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).signOut()
    }

    func notificationSwitchHandler(sender: UISwitch) {
        Settings.reverseNotificationEnabled()
    }

    func manageCalendars() {
        navigationController?.pushViewController(CalendarPickerViewController(), animated: true)
    }
}

//MARK: Private

private extension SettingsViewController {
    
    func setuptCollectionView() {
        
        aView?.collectionView?.delegate = self
        aView?.collectionView?.dataSource = self
        aView?.collectionView?.registerClass(SettingsCell.self, forCellWithReuseIdentifier: SettingsCell.reuseIdentifier)
        aView?.collectionView?.registerClass(SettingsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SettingsCollectionViewHeader.reuseIdentifier)
    }
}
