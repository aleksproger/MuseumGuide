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
        headerView.isSkeletonable = true

        tableView.backgroundColor = .white
        tableView.dataSource = handler.tableViewWorker
        tableView.register(MuseumCell.self, forCellReuseIdentifier: "\(MuseumCell.self)")
        tableView.register(ContactsCell.self, forCellReuseIdentifier: "\(ContactsCell.self)")

        //TODO: Initialy was .never
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false

        drawerView = DrawerView(scrollView: tableView, delegate: handler.tableViewWorker, headerView: headerView)
        drawerView.addListener(handler.pullingViewWorker)
        drawerView.middlePosition = .fromBottom(Layout.middleInsetFromBottom)
        drawerView.bottomPosition = .init(offset: Layout.bottomInset, edge: .bottom, point: .drawerOrigin, ignoresSafeArea: false, ignoresContentSize: false)
        drawerView.cornerRadius = Layout.cornerRadius
        drawerView.containerView.backgroundColor = .white
        drawerView.layer.shadowRadius = Layout.shadowRadius
        drawerView.layer.shadowOpacity = Layout.shadowOpacity
        drawerView.layer.shadowOffset = Layout.shadowOffset
        drawerView.isUserInteractionEnabled = false

        view.addSubview(drawerView)
        setupLayout()
        headerView.showAnimatedGradientSkeleton()
        drawerView.setState(.bottom, animated: true)
        drawerView.setState(.inactive)
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
    
    func showInfo(info: MuseumHeaderView.Info) {
        headerView.update(with: info)
        //tableView.reloadData()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        drawerView.setState(drawerView.interactionState.presentationType, animated: true)
        drawerView.setState(.active)
    }
    
    func hideInfo() {
        drawerView.setState(.bottom, animated: true)
    }
}

extension DrawerView {
    enum InteractionState {
        case inactive, active
        
        var presentationType: State {
            switch self {
            case .inactive:
                return .bottom
            default:
                return .middle
            }
        }
    }
    
    var interactionState: InteractionState {
        get {
            if !self.headerView.isUserInteractionEnabled, !self.isUserInteractionEnabled {
                return .inactive
            } else {
                return .active
            }
        }
        
        set(state) {
            setState(state)
        }
    }
    
    func setState(_ state: InteractionState) {
        switch state {
        case .inactive:
            self.headerView.isUserInteractionEnabled = false
            self.isUserInteractionEnabled = false
        case .active:
            self.headerView.isUserInteractionEnabled = true
            self.isUserInteractionEnabled = true
        }
    }
}
