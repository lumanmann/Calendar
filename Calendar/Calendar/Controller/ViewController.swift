//
//  ViewController.swift
//  Calendar
//
//  Created by WY NG on 18/4/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChangeMonthDelegate {

    var currentMonth = 0
    var currentYear = 0
    var currentDay = 0
    
    lazy var calendarView: CalendarView = {
        let view = CalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let weekView: WeekView = {
        let view = WeekView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let addEventButton: UIBarButtonItem = {
        let menuButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
        return menuButton
    }()
    
    let eventsTableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let insets = UIApplication.shared.delegate?.window??.safeAreaInsets ?? UIEdgeInsets.zero
       // let padding = CGFloat(calendarView.firstRowtoShow)*(screenWidth/7) + 20
       
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.setLayout()
        calendarView.scrollToFirstDay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //calendarView.scrollToMonth()
    }
    
    func changeMonth() {
        self.title = "\(calendarView.year)年\(calendarView.month)月"
    }
    
    func setupView() {
        view.addSubview(weekView)
        view.addSubview(calendarView)
        //view.addSubview(eventsTableView)
        
        weekView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, trailing: nil, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: screenWidth, height: 30)
        
        calendarView.anchor(top: weekView.bottomAnchor, leading: nil, trailing: nil, bottom: nil, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: screenWidth, height: screenWidth/7 * CGFloat(calendarView.rowOfMonth))
        
       // eventsTableView.anchor(top: view.centerYAnchor, leading: nil, trailing: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: screenWidth, height: nil)
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        calendarView.delegate = self
        
        setNavBar()
    }
    
    fileprivate func setNavBar() {
        self.title = "\(calendarView.year)年\(calendarView.month)月"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
    }
    
    @objc func addEvent(sender: UIButton) {
        let vc = AddEventViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count == 0 ? 1 : events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if events.count == 0 {
            cell?.textLabel?.text = "No data"
        }
        //e
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/7, height: screenWidth/7)
    }
    
    
}
