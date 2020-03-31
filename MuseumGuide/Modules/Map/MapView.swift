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
    
    private var infoView: DrawerView!
    private var isFirstLayout = true
    
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
        setupViews()
        setupLayout()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        tableView.contentInset.bottom = view.safeAreaInsets.bottom
        tableView.verticalScrollIndicatorInsets.bottom = view.safeAreaInsets.bottom
    }
    
    //MARK: - Methods
    
    @IBAction func handleMapTap(_ sender: UITapGestureRecognizer) {
        handler.handleMapTap(sender: sender)
    }
    
    func updateHeader(with info: MuseumHeaderView.Info) {
        headerView.update(with: info)
    }
    
    func showInfo() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        infoView.setState(infoView.interactionState.presentationType, animated: true)
        infoView.setState(.active)
    }
    
    func hideInfo() {
        infoView.setState(.bottom, animated: true)
    }
}

//MARK: - Layouts

private extension MapViewController {
    
    private func setupLayout() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        infoView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        infoView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setupViews() {
        setupMapView()
        setupTableView()
        setupHeaderView()
        setupInfoView()
    }
    func setupMapView() {
        mapView.delegate = handler as? MGLMapViewDelegate
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserHeadingIndicator = true
        mapView.gestureRecognizers?.forEach { $0.delegate = self }
    }
    
    func setupTableView() {
        tableView.backgroundColor = .white
        tableView.dataSource = handler.tableViewWorker
        tableView.register(MuseumCell.self, forCellReuseIdentifier: "\(MuseumCell.self)")
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "\(ContactsCell.self)")
        //TODO: Initialy was .never
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
    }
    
    func setupHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: Layout.headerHeight).isActive = true
        headerView.isSkeletonable = true
    }
    
    func setupInfoView() {
        infoView = DrawerView(scrollView: tableView, delegate: handler.tableViewWorker, headerView: headerView)
        infoView.addListener(handler.pullingViewWorker)
        infoView.middlePosition = .fromBottom(Layout.middleInsetFromBottom)
        infoView.bottomPosition = .init(offset: Layout.bottomInset, edge: .bottom, point: .drawerOrigin, ignoresSafeArea: false, ignoresContentSize: false)
        infoView.cornerRadius = Layout.cornerRadius
        infoView.containerView.backgroundColor = .white
        infoView.layer.shadowRadius = Layout.shadowRadius
        infoView.layer.shadowOpacity = Layout.shadowOpacity
        infoView.layer.shadowOffset = Layout.shadowOffset
        infoView.isUserInteractionEnabled = false
        mapView.addSubview(infoView)
        infoView.setState(.inactive)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let isInsideInfoView = infoView.point(inside: touch.location(in: infoView), with: nil)
        return !isInsideInfoView
    }
}
