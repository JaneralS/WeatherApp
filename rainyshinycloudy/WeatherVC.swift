//
//  WeatherVC.swift
//  rainyshinycloudy
//
//  Created by Yizhen Shi on 12/17/16.
//  Copyright © 2016 Yizhen Shi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import GooglePlacePicker

class WeatherVC: UIViewController, UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate{

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!


    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var celsius: UIButton!
    @IBOutlet weak var fahrenheit: UIButton!
    

    var forecast: Forecast!
    var currentWeather = CurrentWeather()
    public static var F2Ccontrol = true
    
    
    
    var forecasts = [Forecast]()
    
    var weatherCell = WeatherCell()



    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        currentWeather = CurrentWeather()
        weatherCell = WeatherCell()
        print(1)


                
        
    }
    
        
    @IBAction func celsiusPressed(_ sender: UIButton!) {
        celsius.setTitleColor(UIColor.white, for: .normal)
        fahrenheit.setTitleColor(UIColor.lightGray, for: .normal)
        currentWeather._currentTemp = currentWeather._currentTempC
        WeatherVC.F2Ccontrol = true
        self.forecasts.removeAll()
        currentWeather.downloadWeatherDetails {
            self.downloadForecastData {
                self.updateMainUI()
                
            }
            
        }
    }
    
    
    
    
    @IBAction func fahrenheitPressed(_ sender: Any) {
        celsius.setTitleColor(UIColor.lightGray, for: .normal)
        fahrenheit.setTitleColor(UIColor.white, for: .normal)
        currentWeather._currentTemp = currentWeather._currentTempF
        WeatherVC.F2Ccontrol = false
        self.forecasts.removeAll()
        currentWeather.downloadWeatherDetails {
            self.downloadForecastData {
            self.updateMainUI()
            
            }
            
        }
        
        


    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj   in list  {
                        
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                    
                }
            }
            completed()
            
        }
    }

    
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell{
            
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
            
        }else{
            return WeatherCell()
        }
    }


    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
        

    
    
    



    
    
    
   





}

