//
//  CalendarViewController.swift
//  Calendar
//
//  Created by WY NG on 18/4/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

protocol ChangeMonthDelegate {
    func changeMonth()
}


class CalendarView: UIView {
    var delegate: ChangeMonthDelegate?
    var numOfDaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = 0
    var currentYear = 0
    var currentDay = 0
    var month = 0
    var year = 0
    var firstWeekDayOfMonth = 0   // 1 = Sun, 2 = Mon
    var firstWeekDayOfLastMonth = 0
    var condition: CGFloat = 0.0
    var max = 0
    var lastRowtoShow = 0
    
    var rowOfMonth: Int {
        get {
            if (currentMonth-1 > 0) {
                return numOfDaysInMonths[currentMonth-1]/7 + 1
            } else {
                return numOfDaysInMonths[0]/7 + 1
            }
            
        }
    }
    
    var rowOfLastMonth: Int {
        get {
            if (currentMonth-2 > 0) {
                return numOfDaysInMonths[currentMonth-2]/7 + 1
            } else {
                return numOfDaysInMonths[0]/7 + 1
            }
        }
    }
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight/4*3), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.gray
        collectionView.allowsMultipleSelection = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
        self.backgroundColor = .yellow
        // add slide gesture
        let pan = UISwipeGestureRecognizer(target: collectionView, action: #selector(swipeAction))
        self.addGestureRecognizer(pan)
        
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initializeView() {
        let date = Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        currentYear = date.year ?? 0
        currentMonth = date.month ?? 0
        currentDay = date.day ?? 0
        firstWeekDayOfMonth = getFirstWeekday(month: currentMonth)
        firstWeekDayOfLastMonth = getFirstWeekday(month: currentMonth-1)
        print(currentYear, currentMonth, currentDay, firstWeekDayOfMonth)
        
        if currentMonth == 2 && currentYear % 4 == 0 {
            numOfDaysInMonths[currentMonth-1] = 29
        }
        
        month = currentMonth
        year = currentYear
        max = numOfDaysInMonths[currentMonth-2] + numOfDaysInMonths[currentMonth-1] +
            numOfDaysInMonths[currentMonth] + firstWeekDayOfLastMonth
        lastRowtoShow = (rowOfMonth/2 + rowOfLastMonth)
        
        self.backgroundColor = UIColor.white  
        self.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
       
        
    }
    
    func setLayout() {
        collectionView.anchor(top: self.topAnchor, leading: nil, trailing: nil, bottom: self.bottomAnchor, paddingTop: 0, paddingLeading: 0, paddingTrailing: 0, paddingBottom: 0, width: screenWidth, height: nil)
    }
    
    func scrollToFirstDay() {
        print(lastRowtoShow)
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: lastRowtoShow*7, section: 0), at: .centeredVertically, animated: true)
        
    }
    
    
    
    func getFirstWeekday(month: Int) -> Int {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        guard let day = String.dateFormatter.date(from: "\(currentYear)-\(month)-01") else {
            return -1
        }
        
        return day.weekday
    }
    
    func didChangeMonth(month: Int) {
        currentMonth = month+1
        
        // leap year
        if month == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonths[month] = 29
            } else {
                numOfDaysInMonths[month] = 28
            }
        }
        
        
        firstWeekDayOfLastMonth = getFirstWeekday(month: currentMonth-1)
        
        collectionView.reloadData()
        
        if let delegate = delegate {
            delegate.changeMonth()
        }
        
        
    }
    
    @objc func swipeAction(sender: UIPanGestureRecognizer) {
        // get the coordinates of finger tap
        
        let point = sender.translation(in: sender.view)
        print(point)
        self.condition += point.y
        print(point.y)
        print(collectionView.frame.origin.y)
        if (collectionView.frame.origin.y) >= CGFloat(integerLiteral: 0) {
            // clear the position
            // As the point is added progressively, we need to set it back to zero to make sure the coordinates are not affected by the last translation
            // ref: https://stackoverflow.com/questions/29558622/pan-gesture-why-need-settranslation-to-zero
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self)
            
            
        } else {
            // slide up
            
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self)
            
        }
        
        if sender.state == .ended {
            if self.condition < self.frame.height * CGFloat(0.5) {
                
                print("up")
                didChangeMonth(month: -1)
            } else if self.condition > self.frame.height * CGFloat(-0.5) {
                
                print("down")
                didChangeMonth(month: 1)
            } else {
                
                print("center")
            }
        }
        
        
    }
    
    
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//        // TODO: finish
//        if scrollView.contentOffset.y >= self.frame.height/2 {
//            // down
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return ((numOfDaysInMonths[currentMonth-1] + firstWeekDayOfMonth)/7 + 1)*7
        return max
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CalendarCollectionViewCell
        
        // Configure the cell
        cell.backgroundColor = UIColor.clear
        cell.isUserInteractionEnabled = false
        cell.label.textColor = UIColor.lightGray
        
        
        var day = indexPath.row-firstWeekDayOfLastMonth+2


        // when indexPath is small then the firstdate of last month-> hide the cell
        if indexPath.item <= firstWeekDayOfLastMonth-2 || indexPath.item > max {
            cell.isHidden = true
        } else {
            cell.isHidden = false
            if indexPath.item <= numOfDaysInMonths[currentMonth-2]-2+firstWeekDayOfLastMonth {
                //lastmonth
            } else if indexPath.item <= max - numOfDaysInMonths[currentMonth-1]-2 {
                //current moth
                day -= numOfDaysInMonths[currentMonth-2]
                cell.label.textColor = UIColor.black
                cell.isUserInteractionEnabled = true

                if year == currentYear &&  month == currentMonth && day == currentDay {
                    cell.backgroundColor = UIColor.yellow
                } else {
                    cell.isUserInteractionEnabled = true

                }
            } else {
                day = indexPath.item - numOfDaysInMonths[currentMonth-2] -
                    numOfDaysInMonths[currentMonth-1] - firstWeekDayOfLastMonth+1
                cell.label.textColor = UIColor.lightGray

            }
        }
        
//                var day = indexPath.item-firstWeekDayOfMonth+2
//
//                if indexPath.item <= firstWeekDayOfMonth-2 {
//                    day = numOfDaysInMonths[currentMonth-1]-(indexPath.item+1)
//                    cell.label.textColor = UIColor.lightGray
//                    cell.isUserInteractionEnabled = false
//                } else if day > numOfDaysInMonths[currentMonth-1] {
//
//                    day -= numOfDaysInMonths[currentMonth-1]
//                    cell.label.textColor = UIColor.lightGray
//                    cell.isUserInteractionEnabled = false
//                } else {
//                    cell.label.text = "\(day)"
//                    cell.label.textColor = UIColor.black
//                    cell.isUserInteractionEnabled = true
//                    if year == currentYear &&  month == currentMonth && day == currentDay {
//
//                        cell.backgroundColor = UIColor.yellow
//                    } else {
//                        cell.isUserInteractionEnabled = true
//
//                    }
//                }
        cell.label.text = "\(day)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cellToDeselect: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        cellToDeselect.backgroundColor = UIColor.clear
    }
    
    
}
