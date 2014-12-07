//
//  CalenderView.swift
//  SwiftCalenderDemo
//
//  Created by kitano on 2014/12/05.
//  Copyright (c) 2014年 OneWorld Inc. All rights reserved.
//

import UIKit

class CalenderView: UIView,UIScrollViewDelegate{

    var currentYear:Int = 0
    var currentMonth:Int = 0
    var currentDay:Int = 0
    var scrollView:UIScrollView!
    var prevMonthView:MonthView!
    var currentMonthView:MonthView!
    var nextMonthView:MonthView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame:CGRect){
        super.init(frame: frame)
        
        var dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        var dateString:String = dateFormatter.stringFromDate(NSDate());
        var dates:[String] = dateString.componentsSeparatedByString("/")
        currentYear  = dates[0].toInt()!
        currentMonth = dates[1].toInt()!
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize   = CGSizeMake(frame.size.width *  3.0,frame.size.height);
        scrollView.contentOffset = CGPointMake(frame.size.width , 0.0);
        scrollView.delegate = self;
        scrollView.pagingEnabled = true;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        
        
        self.addSubview(scrollView)
        
        
        currentMonthView = MonthView(frame: CGRectMake(frame.size.width, 0, frame.size.width,frame.size.height),
            year:currentYear,month:currentMonth)
        
        //翌月
        var ret = self.getNextYearAndMonth()
        nextMonthView =  MonthView(frame: CGRectMake(frame.size.width * 2.0, 0, frame.size.width,frame.size.height),
            year:ret.year,month:ret.month)
        
        //前月
        ret = self.getPrevYearAndMonth()
        prevMonthView = MonthView(frame: CGRectMake(0.0, 0, frame.size.width,frame.size.height),
            year:ret.year,month:ret.month)
        
        scrollView.addSubview(currentMonthView);
        scrollView.addSubview(nextMonthView);
        scrollView.addSubview(prevMonthView);

    }
    
    func scrollViewDidScroll(scrollView:UIScrollView)
    {
        var pos:CGFloat  = scrollView.contentOffset.x / scrollView.bounds.size.width
        var deff:CGFloat = pos - 1.0
        if fabs(deff) >= 1.0 {
            if (deff > 0) {
                self.showNextView()
            } else {
                self.showPrevView()
            }
        }
    }
    
    func showNextView (){
        currentMonth++;
        if( currentMonth > 12 ){
            currentMonth = 1;
            currentYear++;
        }
        var tmpView:MonthView = currentMonthView
        currentMonthView = nextMonthView
        nextMonthView    = prevMonthView
        prevMonthView    = tmpView

        var ret = self.getNextYearAndMonth()
        nextMonthView.setUpDays(ret.year, month:ret.month)
        
        self.resetContentOffSet()
        
    }
    
    func showPrevView () {
        currentMonth--
        if( currentMonth == 0 ){
            currentMonth = 12
            currentYear--
        }

        var tmpView:MonthView = currentMonthView
        currentMonthView = prevMonthView
        prevMonthView    = nextMonthView
        nextMonthView    = tmpView
        var ret = self.getPrevYearAndMonth()
        prevMonthView.setUpDays(ret.year, month:ret.month)

        //position調整
        self.resetContentOffSet()
    }
    
    
    func resetContentOffSet () {
        //position調整
        prevMonthView.frame = CGRectMake(0, 0, frame.size.width,frame.size.height)
        currentMonthView.frame = CGRectMake(frame.size.width, 0, frame.size.width,frame.size.height)
        nextMonthView.frame = CGRectMake(frame.size.width * 2.0, 0, frame.size.width,frame.size.height)
        
        var scrollViewDelegate:UIScrollViewDelegate = scrollView.delegate!
        scrollView.delegate = nil
        //delegateを呼びたくないので
        scrollView.contentOffset = CGPointMake(frame.size.width , 0.0);
        scrollView.delegate = scrollViewDelegate
        
    }
    
    func getNextYearAndMonth () -> (year:Int,month:Int){
        var next_year:Int = currentYear
        var next_month:Int = currentMonth + 1
        if next_month > 12 {
            next_month=1
            next_year++
        }
        return (next_year,next_month)
    }
    func getPrevYearAndMonth () -> (year:Int,month:Int){
        var prev_year:Int = currentYear
        var prev_month:Int = currentMonth - 1
        if prev_month == 0 {
            prev_month = 12
            prev_year--
        }
        return (prev_year,prev_month)
    }
    
}
