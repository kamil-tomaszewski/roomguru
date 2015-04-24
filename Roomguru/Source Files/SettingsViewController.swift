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
    private let viewModel = ListViewModel<SettingItem>([
        SettingItem(title: NSLocalizedString("Manage calendars", comment: ""), mode: .Selectable, action: Selector("didTapManageCalendars"))
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
        return viewModel.itemsCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SettingsCell.reuseIdentifier(), forIndexPath: indexPath) as! SettingsCell
        
        if let item: SettingItem = viewModel[indexPath.row] {
            cell.textLabel.text = item.title
            cell.switchControl.addTarget(self, action: item.action, forControlEvents: .ValueChanged)
            cell.switchControl.hidden = (item.mode != .Switchable)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if self.header == nil {
            self.header = (collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: SettingsCollectionViewHeader.reuseIdentifier(), forIndexPath: indexPath) as! SettingsCollectionViewHeader)
        }
        return header!
    }
}

//MARK: UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
   
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let item: SettingItem = viewModel[indexPath.row] {
            NSThread.detachNewThreadSelector(item.action, toTarget:self, withObject: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if let item: SettingItem = viewModel[indexPath.row]  {
            return item.mode == .Selectable
        }
        return false
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

    func didTapManageCalendars() {
        navigationController?.pushViewController(CalendarPickerViewController(), animated: true)
    }
}

//MARK: Private

private extension SettingsViewController {
    
    func setuptCollectionView() {
        
        aView?.collectionView?.delegate = self
        aView?.collectionView?.dataSource = self
        aView?.collectionView?.registerClass(SettingsCell.self, type: .Cell)
        aView?.collectionView?.registerClass(SettingsCollectionViewHeader.self, type: .Header)
    }
}
