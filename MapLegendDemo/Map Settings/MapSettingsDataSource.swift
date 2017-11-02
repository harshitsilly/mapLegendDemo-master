//
//  MapSettingsDataSource.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 7/24/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class MapSettingsDataSource {
    var data: [String]
    
    init() {
        var mapViewOptions = "Map View Options"
        var featureLayersOptions = "Feature Layers Options"
        var nearMeRadius = "Near Me Radius"
        var mapUnitOfMeasure = "Map Unit of Measure"
        data = [mapViewOptions, featureLayersOptions, nearMeRadius, mapUnitOfMeasure]
    }
}
