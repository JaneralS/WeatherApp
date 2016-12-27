//
//  Forecast.swift
//  rainyshinycloudy
//
//  Created by Yizhen Shi on 12/18/16.
//  Copyright © 2016 Yizhen Shi. All rights reserved.
//

import UIKit
import Alamofire


class Forecast{
    
    var _date:String!
    var _weatherType: String!
    var _highTemp: Double!
    var _lowTemp: Double!
    var _highTempC: Double!
    var _highTempF: Double!
    var _lowTempC: Double!
    var _lowTempF: Double!
    var weathervc = WeatherVC()
    
    
    var date: String{
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherType: String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var highTemp: Double{
        if _highTemp == nil{
            _highTemp = 0.0
        }
        
        if WeatherVC.F2Ccontrol == true{
            _highTemp = _highTempC
            
        }else{
            _highTemp = _highTempF    
        }
        
        return _highTemp
    }
    
    var lowTemp: Double{
        if _lowTemp == nil{
            _lowTemp = 0.0
        }
        if WeatherVC.F2Ccontrol == true{
            _lowTemp = _lowTempC
            
        }else{
            _lowTemp = _lowTempF
        }
        return _lowTemp
    }
    
    var highTempC: Double{
        if _highTempC == nil{
            _highTempC = 0.0
        }
        return _highTempC
    }
    
    var highTempF: Double{
        if _highTempF == nil{
            _highTempF = 0.0
        }
        return _highTempF
    }
    
    var lowTempC: Double{
        if _lowTempC == nil{
            _lowTempC = 0.0
        }
        return _lowTempC
    }
    
    var lowTempF: Double{
        if _lowTempF == nil{
            _lowTempF = 0.0
        }
        return _lowTempF
    }
    
    
    
    init(weatherDict: Dictionary<String, AnyObject>){
        
        // get the temp
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject>{
            
            // get the lowtemp
            if let min = temp["min"] as? Double{
                let kelvinToCelsius = Double(round(10*(min - 273.15)/10))
                
                let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._lowTempC = kelvinToCelsius
                self._lowTempF = kelvinToFarenheit
                
                
                
            }
            
            // get the hightemp
            if let max = temp["max"] as? Double{
                let kelvinToCelsius = Double(round(10*(max - 273.15)/10))
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._highTempC = kelvinToCelsius
                self._highTempF = kelvinToFarenheit
                print(WeatherVC.F2Ccontrol)

            }
 
        }
        // end of get temp
        
        // get the weather type
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }        // end of get weahter type
        if let date = weatherDict["dt"] as? Double {
            
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        
    
    }// end of init\
    
    
    
   
}

extension Date{
    func dayOfTheWeek() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}



