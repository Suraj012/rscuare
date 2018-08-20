//
//  ViewController.swift
//  Rscuare
//
//  Created by suraj on 8/16/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isLoading = true
    
    
    lazy var refreshSwipe: UIRefreshControl = {
        let refreshSwipe = UIRefreshControl()
        refreshSwipe.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshSwipe.tintColor = UIColor.gray
        return refreshSwipe
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFirebaseEmotionData()
        self.tableView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        self.tableView.addSubview(self.refreshSwipe)
        
        var frame = spinner.frame
        frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2);
        frame.origin.y = (self.view.frame.size.height / 2.5 - frame.size.height / 2);
        spinner.frame = frame;
        self.view.addSubview(spinner)
        //        spinner.startAnimating()
        loadData()
    }
    
    func loadData(){
        let connection = Connection(url: "http://159.203.12.221:8000/predict/personality/oG7EZmjlh3Oz43wiCXjsEk1UTwh1", parameters: [
            "token"       :"ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAici1zY3VhcmUtNWVkOGEiLAogICJwcml2YXRlX2tleV9pZCI6ICJiNjRhODU2NDc1NWMzNTNmMWI4NTQwNDkyMDQ0YWNiZDIxOTEwNTY3IiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdmdJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLZ3dnZ1NrQWdFQUFvSUJBUURCZ2duMGR6Vzg3VXVOXG5NVUdTeThyR1hDYVdUZlVZUk9KVlFTSTNVQStBK0NyZlhlc2tNS2YrYkhSWllQTEQxazdoY0Q3SXQ2ZEYrRkpZXG5vb05NR0NhMEtDSXQ0TlB4NHBEWnV5eEtOSWhQV0R6QXVHdllqZEZvUWZDUjhNRndvSk14L3pWR0FkMVFaTUlKXG5yUXdCUWs0MXB4SkR1UEF1VTdUUTBuUFVhempSVW1UVmg4aGVFZ1FJekk4aER5WjU5MlpLYW5zZUJ0RzNXKzc0XG5QRldMK3JmbS93ZGFUdURaT2h0eUJtSVVLS2hwdDlkcWI1Y2NyVVM4TmFrNkRIL05taS9LVEkvdG0wRWdvQmNMXG45VmZJTGRhNllPTEI3TFJ2THNCbGJvNUoxWm5lcU9CMU5aUXJMclozRUZGR3R6NkptNGZLT1pQcU5yR0JmdWRWXG5kSUJ5MmJVL0FnTUJBQUVDZ2dFQUR6VEd6MzBtcmVmL3plS1hBcEFkS1NWSXF2c0pUWlRzTEVMb0MyeXhLek5WXG5PeVJJUEJuT3VjR1FDdzRCUmI1cmlHK25uMkkvTk5Ka3RpNWZIdld1NU8xYWNqeCtxejFnb0p1Q3lYb0RWQ2pjXG43VkFRdVgyN2ZQUGhrYlpYblNBaE1RYWJDeHRPWnVqa0RwcVluT2kyK0tSZVhSQUZYNzZZTU9pNHpYSjNqb3RGXG4rc0NtMVRBRVJmclkwWnhGSDAzR2VhbGluSlc3S2xTVzFBVXRyUWZSMXoxYjhPRnk3ejFMbDU5U3kvcUs1dEJmXG5TUjc2czdyZzN5YWo3V2dLMlE4S2dqalNqSHdXeFV6MnF5endFdHk2emw1SXJBNk41WGtyWHZuV21Hc1cvZTRtXG43RUh2VGpzdlczSTRuRWtRbWlXMlZLWnJQSnNVQkN5amF5eDRldWFXRVFLQmdRRG4xbTRDdmxxTUhiOG5xQkpTXG5jS3VmakM0cXZnT0xRWGlmZ21QOFR1d214NmtMR2xucXNac0x1V1NlMW9Uc0N2Zzh6U0piSnpmYWczcjVWQmVKXG4wQkpNR1hHZzRJSlF1Ulg4TE0vVkRtWGo4RUI5bHd1YWIvLzFlUDZzaXNYUk1nMHJ6UU5QVEdERW5IZTBaYjF5XG50WlJMTmh6cjlGL3c4ZEFRQ3hlMlN2Vlptd0tCZ1FEVnJQTlJhYkRWa2RHMnlQYnRIRmJzRFhwdnNXc3R6VW5BXG5rUzlCSzBsSGdEVlJWdHB0SDQ2ZHZrRFBUaE9KWnFOMnYvdzN2Mzd0MlZBTzF2SkRsS2FoZy9PbWdzYW9qbE5UXG4xTG90VmdaL25BckZGcUwzeTdzZzBDUngvUU92TERRUi9WckE3MkgvY1ZXQTBXSWo4NGNweFVsTTE4eVVwK2lGXG4rZkJ4RytpdkxRS0JnQmcyMkVTbkZ4UDlZMkxEOWkzd0lLeklXbVlTZEpKTjQwaGR1UTI0UElnTVlJYU5XUWpmXG5SZjlpZkxUdVdQSENiNDBDSysxeldpMFRnSHVjSWQwK0F6czVpUm14ZVVydkdmRzl5SE5MVHE4US85dGVORk1NXG5FYUxVNFZ5cUhlRXNwaDJHQ3l0MEljTkhTR1ZxSHZCbE1ManVUUFVFRUNVOVRHcndqYWgzaWNxekFvR0JBTTZtXG5RM1BiT2JCekpGVVlxdWJLWDY1UG9yZmU2SDhWYVZ5WmpSQUQ0dzBKaTRjczduWlc3TURXUFN2QW9OaGpzWGVwXG5XUzQ1UDNLY2x2YWpIdzRJOTlhQkhPVk8yUDR2RjV1ZHdxa1I1NXNHdU11L2hzRU1BZUJNTE5NcEZhVVdwUTA0XG43OHBrT1d5b21UN0tRWlh2Y2lzTnFFUnUrR1pVdFdiTlFLTERrUmZKQW9HQkFJc0RVZkFlZWZvMkFIZVkyU1FwXG56U28xR3hGRjIrcUtIbVZpcmJpL2tBa2ErSjRtWVdzSVkrWFZEbWtnWFppNHlRR1hZUCtVOGpsK3NaZnhHYkhwXG53QUUrUVZEUmhDVnBlaWhpcjhRRitEb2xuUFNwVlRsdGhlTWtUemwyeUxZYkNONlRNc0M4Q1BoZ1RUVGpJODdIXG5OdVVma3h5cmYxOTVJYjRnM1R6YTZwM2pcbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJmaXJlYmFzZS1hZG1pbnNkay03NGhudUByLXNjdWFyZS01ZWQ4YS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMDQxNjAyMzcxMTE5MjY3MTMxMTQiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvdG9rZW4iLAogICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwKICAiY2xpZW50X3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vcm9ib3QvdjEvbWV0YWRhdGEveDUwOS9maXJlYmFzZS1hZG1pbnNkay03NGhudSU0MHItc2N1YXJlLTVlZDhhLmlhbS5nc2VydmljZWFjY291bnQuY29tIgp9",
            ])
        connection.start { (result, success) -> Void in
            if success {
                let data = result[0]
                dump("here -\(data)")
                self.isLoading = false
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshSwipe.endRefreshing()
            } else {
                self.view.makeToast("Please try again later.")
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if indexPath.section == 0 {
            return 150
        }else{
            return screenHeight - 150
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "personality_profile", for: indexPath) as! PieChartCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic_profile", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 1){
            return "Personality Profile"
        }else if(section == 2){
            return "Character Profile"
        }else{
            return ""
        }
    }
    
    
    @objc func handleRefresh(_ refreshSwipe: UIRefreshControl) {
        refreshSwipe.endRefreshing()
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
    }
}
