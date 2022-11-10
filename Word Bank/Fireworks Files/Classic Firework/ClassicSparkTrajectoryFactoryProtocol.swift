//
//  ClassicSparkTrajectoryFactoryProtocol.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public protocol ClassicSparkTrajectoryFactoryProtocol: SparkTrajectoryFactory {

    func randomTopRight() -> SparkTrajectory
    func randomBottomRight() -> SparkTrajectory
}

