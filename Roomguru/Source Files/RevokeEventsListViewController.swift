//
//  RevokeEventsListViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

// NGRTemp: temporary disabled due to EventsListViewController structure changes

class RevokeEventsListViewController: EventsListViewController {
    
    
//    override func filterEvents(events: [Event]) -> [Event] {
//        let userEmail = UserPersistenceStore.sharedStore.user?.email
//        return events.filter { !$0.isCanceled() && $0.creator?.email == userEmail }
//    }
//    
//    override func createProperCalendarEntries(entries: [CalendarEntry]) -> [CalendarEntry] {
//        return CalendarEntry.sortedByDate(entries)
//    }
//    
//    override func setupTableView() {
//        super.setupTableView()
//        aView?.tableView.registerClass(RevocableEventCell.self)
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let event = eventFromIndexPath(indexPath)
//        let cell = tableView.dequeueReusableCell(RevocableEventCell.self)
//        cell.textLabel?.text = event?.summary
//        cell.timeMaxLabel.text = event?.startTime
//        cell.timeMinLabel.text = event?.endTime
//        cell.revokeButtonHandler = { [weak self] in
//            self?.revokeEventAtIndexPath(indexPath)
//        }
//        return cell
//    }
//    
//    func revokeEventAtIndexPath(indexPath: NSIndexPath){
//        if let event = eventFromIndexPath(indexPath){
//            BookingManager.revokeEvent(event, success: {
//                self.viewModel?.removeAtIndexPath(indexPath)
//                self.aView?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                }, failure: { error in
//                    UIAlertView(error: error).show()
//            })
//        }
//    }

}
