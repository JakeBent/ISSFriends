//
//  MapViewController.swift
//  ISSFriends
//
//  Created by Jacob Benton on 4/7/16.
//  Copyright © 2016 jakebent. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

// This is the main view controller, housing the map view. You can tap on the bottom right satellite dish icon to center the map on the ISS, or tap on the bottom left clock icon to view the list of friends you have saved. In order to add friends to that list, long press (~1 second) on a location and enter a name for that friend.
class MapViewController: UIViewController {

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    let viewModel = MapViewModel()
    let satellite = Satellite(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    let findISSButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "find_iss"), forState: .Normal)
        return button
    }()
    let viewFriendsPassTimesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "clock"), forState: .Normal)
        return button
    }()
    let myNextPassTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .Center
        label.font = .systemFontOfSize(10)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        view.addSubview(mapView)
        view.addSubview(findISSButton)
        view.addSubview(viewFriendsPassTimesButton)
        view.addSubview(myNextPassTimeLabel)
        mapView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }
        findISSButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-24)
            make.right.equalTo(view.snp_right).offset(-24)
            make.height.equalTo(32)
            make.width.equalTo(findISSButton.snp_height)
        }
        viewFriendsPassTimesButton.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp_bottom).offset(-24)
            make.left.equalTo(view.snp_left).offset(24)
            make.height.equalTo(32)
            make.width.equalTo(viewFriendsPassTimesButton.snp_height)
        }
        myNextPassTimeLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(viewFriendsPassTimesButton.snp_right).offset(12)
            make.right.equalTo(findISSButton.snp_left).offset(-12)
            make.bottom.equalTo(view.snp_bottom).offset(-12)
            make.height.equalTo(32)
        }

        findISSButton.bnd_tap.observe { [weak self] () in
            self?.centerMapOnLocation(self?.satellite.coordinate)
        }

        viewFriendsPassTimesButton.bnd_tap.observe { [weak self] () in
            guard let sself = self else { return }
            let friends = [Friend(name: "dude", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 45.0)),
            Friend(name: "guy", coordinate: CLLocationCoordinate2D(latitude: 43.0, longitude: 41.0)),
            Friend(name: "girl", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 42.0)),
            Friend(name: "thing", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 46.0)),
            Friend(name: "lady", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 54.0)),
            Friend(name: "it", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 55.0)),
            Friend(name: "stuff", coordinate: CLLocationCoordinate2D(latitude: 45.0, longitude: 58.0))]
            let controller = FriendsListViewController(friends: sself.viewModel.friends.array + friends)
            self?.presentViewController(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        }

        let addFriendGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "addFriend:")
        addFriendGestureRecognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(addFriendGestureRecognizer)

        // Whenever the issLocation is updated, update it's annotation's location on the map
        viewModel.issLocation.observeNew { [weak self] (location) -> Void in
            guard let sself = self else { return }
            self?.satellite.coordinate = location.coordinate
            self?.mapView.removeAnnotation(sself.satellite)
            self?.mapView.addAnnotation(sself.satellite)
        }

        // Whenever a friend is added, add an annotation at their location
        viewModel.friends.observe { [weak self] event in
            self?.mapView.removeAnnotations(event.sequence)
            self?.mapView.addAnnotations(event.sequence)
        }

        viewModel.myNextPassTime.observe { [weak self] text in
            self?.myNextPassTimeLabel.text = "The ISS will pass over me at \n\(text)"
        }
    }

    func addFriend(sender: UILongPressGestureRecognizer) {
        guard sender.state == .Began else { return }
        let point: CGPoint = sender.locationInView(view)

        let alertController = UIAlertController(title: "Add a friend?", message: "Enter your friend's name and we'll alert you when the ISS is passing over this location", preferredStyle: .Alert)

        let addFriendAction = UIAlertAction(title: "Add Friend", style: .Default) { [weak self] (_) in
            guard let textFields = alertController.textFields,
                name = textFields[0].text,
                sself = self else { return }

            let coordinate = sself.mapView.convertPoint(point, toCoordinateFromView: sself.mapView)
            let friend = Friend(name: name, coordinate: coordinate)
            self?.viewModel.addFriend(friend)
        }
        addFriendAction.enabled = false

        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Bob Loblaw"

            NSNotificationCenter.defaultCenter()
                .addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addFriendAction.enabled = textField.text != ""
            }
        }
        
        alertController.addAction(addFriendAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))

        presentViewController(alertController, animated: true, completion: nil)
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
            10000000, 10000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        viewModel.requestMyNextPassTime(lastLocation.coordinate)

    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKAnnotationView?

        switch annotation {
        case is Satellite:
            if let reusedView = mapView.dequeueReusableAnnotationViewWithIdentifier(Satellite.annotationViewIdentifier) {
                reusedView.annotation = annotation
                view = reusedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Satellite.annotationViewIdentifier)
                view?.image = UIImage(named: "iss")            }
            break
        case is Friend:
            if let reusedView = mapView.dequeueReusableAnnotationViewWithIdentifier(Friend.annotationViewIdentifier) {
                reusedView.annotation = annotation
                view = reusedView
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: Friend.annotationViewIdentifier)
                view?.image = UIImage(named: "friend")
            }
            break
        default:
            return nil
        }

        return view
    }
}