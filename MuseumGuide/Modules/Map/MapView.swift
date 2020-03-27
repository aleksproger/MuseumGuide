//
//  MapView.swift
//  MuseumGuide
//
//  Created by Alex on 10.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Mapbox
import UltraDrawerView

class MapViewController: BaseViewController, MapViewBehavior {
    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var mapTap: UITapGestureRecognizer!
    private let tableView = UITableView()
    private var drawerView: DrawerView!
    private var isFirstLayout = true
    private let cellInfos = ShapeCell.makeDefaultInfos()
    let headerView = MuseumHeaderView()
    var handler: MapEventHandler!
    
    private struct Layout {
        static let topInsetPortrait: CGFloat = 36
        static let topInsetLandscape: CGFloat = 20
        static let middleInsetFromBottom: CGFloat = 280
        static let bottomInset: CGFloat = 80
        static let headerHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Float = 0.2
        static let shadowOffset = CGSize.zero
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handler.didLoad()
        setupMapView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: Layout.headerHeight).isActive = true

        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.register(ShapeCell.self, forCellReuseIdentifier: "\(ShapeCell.self)")
        tableView.contentInsetAdjustmentBehavior = .never

        drawerView = DrawerView(scrollView: tableView, delegate: self, headerView: headerView)
        drawerView.middlePosition = .fromBottom(Layout.middleInsetFromBottom)
        drawerView.bottomPosition = .init(offset: Layout.bottomInset, edge: .bottom, point: .drawerOrigin, ignoresSafeArea: false, ignoresContentSize: false)
        drawerView.cornerRadius = Layout.cornerRadius
        drawerView.containerView.backgroundColor = .white
        drawerView.layer.shadowRadius = Layout.shadowRadius
        drawerView.layer.shadowOpacity = Layout.shadowOpacity
        drawerView.layer.shadowOffset = Layout.shadowOffset

        view.addSubview(drawerView)
        setupLayout()
        drawerView.setState(.bottom, animated: true)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
        tableView.verticalScrollIndicatorInsets.bottom = view.safeAreaInsets.bottom
    }
    
    //MARK: - Methods
    private func setupMapView() {
        mapView.delegate = handler as? MGLMapViewDelegate
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserHeadingIndicator = true
    }
    
    private func setupLayout() {
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        drawerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drawerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        drawerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        drawerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    @IBAction func handleMapTap(_ sender: UITapGestureRecognizer) {
        handler.handleMapTap(sender: sender)
    }
    
    func showInfo() {
        //headerView.update(with: info)
        drawerView.setState(.middle, animated: true)
    }
    
    func hideInfo() {
        drawerView.setState(.bottom, animated: true)
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ShapeCell.self)", for: indexPath)
        
        if let cell = cell as? ShapeCell {
            cell.update(with: cellInfos[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ShapeCell.Layout.estimatedHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
