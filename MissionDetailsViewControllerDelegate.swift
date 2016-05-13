//
//  MissionDetailsViewControllerDelegate.swift
//  Bucket List
//
//  Created by Howard Jiang on 5/10/16.
//  Copyright © 2016 Howard Jiang. All rights reserved.
//

import Foundation
protocol MissionDetailsViewControllerDelegate: class {
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishAddingMission mission: String)
    func missionDetailsViewController(controller: MissionDetailsViewController, didFinishEditingMission mission: Mission, atIndexPath indexPath: Int)
}
