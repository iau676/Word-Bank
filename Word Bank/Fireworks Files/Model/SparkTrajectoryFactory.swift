//
//  SparkTrajectoryFactory.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public protocol SparkTrajectoryFactory {}

public protocol DefaultSparkTrajectoryFactory: SparkTrajectoryFactory {

    func random() -> SparkTrajectory
}

