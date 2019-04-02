//
//  ViewController.swift
//  AnimatesRoute
//
//  Created by Idan Boadana on 3/12/19.
//  Copyright © 2019 Idan Boadana. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(map)
        
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        map.delegate = self
        return map
    }()
    
    private var drawingTimer: Timer?
    private var polyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let route = fakeRoute
        center(onRoute: route, fromDistance: 15)
        animate(route: route, duration: 3.5) {
            print("Finished drawing route! 🙂")
        }
    }
}

private extension ViewController {
    func center(onRoute route: [CLLocationCoordinate2D], fromDistance km: Double) {
        let center = MKPolyline(coordinates: route, count: route.count).coordinate
        mapView.setCamera(MKMapCamera(lookingAtCenter: center, fromDistance: km * 1000, pitch: 0, heading: 0), animated: false)
    }
    
    func animate(route: [CLLocationCoordinate2D], duration: TimeInterval, completion: (() -> Void)?) {
        guard route.count > 0 else { return }
        var currentStep = 1
        let totalSteps = route.count
        let stepDrawDuration = duration/TimeInterval(totalSteps)
        var previousSegment: MKPolyline?
        
        drawingTimer = Timer.scheduledTimer(withTimeInterval: stepDrawDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                // Invalidate animation if we can't retain self
                timer.invalidate()
                completion?()
                return
            }
            
            if let previous = previousSegment {
                // Remove last drawn segment if needed.
                self.mapView.removeOverlay(previous)
                previousSegment = nil
            }
            
            guard currentStep < totalSteps else {
                // If this is the last animation step...
                let finalPolyline = MKPolyline(coordinates: route, count: route.count)
                self.mapView.addOverlay(finalPolyline)
                // Assign the final polyline instance to the class property.
                self.polyline = finalPolyline
                timer.invalidate()
                completion?()
                return
            }
            
            // Animation step.
            // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
            let subCoordinates = Array(route.prefix(upTo: currentStep))
            let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
            self.mapView.addOverlay(currentSegment)
            
            previousSegment = currentSegment
            currentStep += 1
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .black
        polylineRenderer.lineWidth = 2
        return polylineRenderer
    }
}

private let fakeRoute = Array([CLLocationCoordinate2D(latitude: 32.10657, longitude: 34.83409),
                               CLLocationCoordinate2D(latitude: 32.1065, longitude: 34.83477),
                               CLLocationCoordinate2D(latitude: 32.10653, longitude: 34.83516),
                               CLLocationCoordinate2D(latitude: 32.10665, longitude: 34.83548),
                               CLLocationCoordinate2D(latitude: 32.10681, longitude: 34.83586),
                               CLLocationCoordinate2D(latitude: 32.10732, longitude: 34.83694),
                               CLLocationCoordinate2D(latitude: 32.10781, longitude: 34.83784),
                               CLLocationCoordinate2D(latitude: 32.10851, longitude: 34.83905),
                               CLLocationCoordinate2D(latitude: 32.10863, longitude: 34.83923),
                               CLLocationCoordinate2D(latitude: 32.10862, longitude: 34.83925),
                               CLLocationCoordinate2D(latitude: 32.10859, longitude: 34.8393),
                               CLLocationCoordinate2D(latitude: 32.10858, longitude: 34.83936),
                               CLLocationCoordinate2D(latitude: 32.1086, longitude: 34.83948),
                               CLLocationCoordinate2D(latitude: 32.10867, longitude: 34.83955),
                               CLLocationCoordinate2D(latitude: 32.10876, longitude: 34.83958),
                               CLLocationCoordinate2D(latitude: 32.10881, longitude: 34.83957),
                               CLLocationCoordinate2D(latitude: 32.10883, longitude: 34.83956),
                               CLLocationCoordinate2D(latitude: 32.1089, longitude: 34.83971),
                               CLLocationCoordinate2D(latitude: 32.10899, longitude: 34.83986),
                               CLLocationCoordinate2D(latitude: 32.10933, longitude: 34.84035),
                               CLLocationCoordinate2D(latitude: 32.10961, longitude: 34.84069),
                               CLLocationCoordinate2D(latitude: 32.11019, longitude: 34.84137),
                               CLLocationCoordinate2D(latitude: 32.1106, longitude: 34.8419),
                               CLLocationCoordinate2D(latitude: 32.11058, longitude: 34.84195),
                               CLLocationCoordinate2D(latitude: 32.11057, longitude: 34.84203),
                               CLLocationCoordinate2D(latitude: 32.11062, longitude: 34.84212),
                               CLLocationCoordinate2D(latitude: 32.1107, longitude: 34.84221),
                               CLLocationCoordinate2D(latitude: 32.11076, longitude: 34.84223),
                               CLLocationCoordinate2D(latitude: 32.11082, longitude: 34.84222),
                               CLLocationCoordinate2D(latitude: 32.11086, longitude: 34.84219),
                               CLLocationCoordinate2D(latitude: 32.11088, longitude: 34.84212),
                               CLLocationCoordinate2D(latitude: 32.11087, longitude: 34.84202),
                               CLLocationCoordinate2D(latitude: 32.11085, longitude: 34.84197),
                               CLLocationCoordinate2D(latitude: 32.11079, longitude: 34.8419),
                               CLLocationCoordinate2D(latitude: 32.11083, longitude: 34.84182),
                               CLLocationCoordinate2D(latitude: 32.11088, longitude: 34.84172),
                               CLLocationCoordinate2D(latitude: 32.11125, longitude: 34.84113),
                               CLLocationCoordinate2D(latitude: 32.11174, longitude: 34.84033),
                               CLLocationCoordinate2D(latitude: 32.11208, longitude: 34.83971),
                               CLLocationCoordinate2D(latitude: 32.11228, longitude: 34.83932),
                               CLLocationCoordinate2D(latitude: 32.11233, longitude: 34.83923),
                               CLLocationCoordinate2D(latitude: 32.11227, longitude: 34.83919),
                               CLLocationCoordinate2D(latitude: 32.11179, longitude: 34.83888),
                               CLLocationCoordinate2D(latitude: 32.11153, longitude: 34.8387),
                               CLLocationCoordinate2D(latitude: 32.1112, longitude: 34.83842),
                               CLLocationCoordinate2D(latitude: 32.11061, longitude: 34.83789),
                               CLLocationCoordinate2D(latitude: 32.11041, longitude: 34.83771),
                               CLLocationCoordinate2D(latitude: 32.10903, longitude: 34.83617),
                               CLLocationCoordinate2D(latitude: 32.10857, longitude: 34.83565),
                               CLLocationCoordinate2D(latitude: 32.10806, longitude: 34.83503),
                               CLLocationCoordinate2D(latitude: 32.10776, longitude: 34.83466),
                               CLLocationCoordinate2D(latitude: 32.10739, longitude: 34.83412),
                               CLLocationCoordinate2D(latitude: 32.10712, longitude: 34.83362),
                               CLLocationCoordinate2D(latitude: 32.10693, longitude: 34.83312),
                               CLLocationCoordinate2D(latitude: 32.10681, longitude: 34.83259),
                               CLLocationCoordinate2D(latitude: 32.10674, longitude: 34.83212),
                               CLLocationCoordinate2D(latitude: 32.10675, longitude: 34.8316),
                               CLLocationCoordinate2D(latitude: 32.10679, longitude: 34.83117),
                               CLLocationCoordinate2D(latitude: 32.10694, longitude: 34.83021),
                               CLLocationCoordinate2D(latitude: 32.10703, longitude: 34.82967),
                               CLLocationCoordinate2D(latitude: 32.10704, longitude: 34.82935),
                               CLLocationCoordinate2D(latitude: 32.10714, longitude: 34.82847),
                               CLLocationCoordinate2D(latitude: 32.10718, longitude: 34.8279),
                               CLLocationCoordinate2D(latitude: 32.10719, longitude: 34.82764),
                               CLLocationCoordinate2D(latitude: 32.10714, longitude: 34.82735),
                               CLLocationCoordinate2D(latitude: 32.10694, longitude: 34.82638),
                               CLLocationCoordinate2D(latitude: 32.10686, longitude: 34.82587),
                               CLLocationCoordinate2D(latitude: 32.10671, longitude: 34.82504),
                               CLLocationCoordinate2D(latitude: 32.10611, longitude: 34.82132),
                               CLLocationCoordinate2D(latitude: 32.10604, longitude: 34.82062),
                               CLLocationCoordinate2D(latitude: 32.10601, longitude: 34.8202),
                               CLLocationCoordinate2D(latitude: 32.10601, longitude: 34.81941),
                               CLLocationCoordinate2D(latitude: 32.10605, longitude: 34.81875),
                               CLLocationCoordinate2D(latitude: 32.10611, longitude: 34.81804),
                               CLLocationCoordinate2D(latitude: 32.10625, longitude: 34.81729),
                               CLLocationCoordinate2D(latitude: 32.1064, longitude: 34.81678),
                               CLLocationCoordinate2D(latitude: 32.10648, longitude: 34.81659),
                               CLLocationCoordinate2D(latitude: 32.10662, longitude: 34.81639),
                               CLLocationCoordinate2D(latitude: 32.1068, longitude: 34.81613),
                               CLLocationCoordinate2D(latitude: 32.10783, longitude: 34.81502),
                               CLLocationCoordinate2D(latitude: 32.10793, longitude: 34.81492),
                               CLLocationCoordinate2D(latitude: 32.1079, longitude: 34.81488),
                               CLLocationCoordinate2D(latitude: 32.10753, longitude: 34.81457),
                               CLLocationCoordinate2D(latitude: 32.10738, longitude: 34.81444),
                               CLLocationCoordinate2D(latitude: 32.10702, longitude: 34.81412),
                               CLLocationCoordinate2D(latitude: 32.10675, longitude: 34.81379),
                               CLLocationCoordinate2D(latitude: 32.10656, longitude: 34.81357),
                               CLLocationCoordinate2D(latitude: 32.10609, longitude: 34.81303),
                               CLLocationCoordinate2D(latitude: 32.10553, longitude: 34.81231),
                               CLLocationCoordinate2D(latitude: 32.10526, longitude: 34.81192),
                               CLLocationCoordinate2D(latitude: 32.10501, longitude: 34.81151),
                               CLLocationCoordinate2D(latitude: 32.10446, longitude: 34.81053),
                               CLLocationCoordinate2D(latitude: 32.10406, longitude: 34.80966),
                               CLLocationCoordinate2D(latitude: 32.10385, longitude: 34.8092),
                               CLLocationCoordinate2D(latitude: 32.10337, longitude: 34.80801),
                               CLLocationCoordinate2D(latitude: 32.10305, longitude: 34.80711),
                               CLLocationCoordinate2D(latitude: 32.10301, longitude: 34.80699),
                               CLLocationCoordinate2D(latitude: 32.10304, longitude: 34.80657),
                               CLLocationCoordinate2D(latitude: 32.10305, longitude: 34.80636),
                               CLLocationCoordinate2D(latitude: 32.10311, longitude: 34.80634),
                               CLLocationCoordinate2D(latitude: 32.10362, longitude: 34.80621),
                               CLLocationCoordinate2D(latitude: 32.10399, longitude: 34.80611),
                               CLLocationCoordinate2D(latitude: 32.10393, longitude: 34.80593),
                               CLLocationCoordinate2D(latitude: 32.10386, longitude: 34.80577),
                               CLLocationCoordinate2D(latitude: 32.10367, longitude: 34.80561),
                               CLLocationCoordinate2D(latitude: 32.1034, longitude: 34.80542),
                               CLLocationCoordinate2D(latitude: 32.10334, longitude: 34.80537)].reversed())
