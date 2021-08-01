//
//  Database.swift
//  GoogleMapProject
//
//  Created by Suhas N on 6/6/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SQLite
class Database {
    var candies: [String]!
    //var dictionary : [String:[String]]!
    var database: Connection!
    let usersTable = Table("usersTable")
    let userId = Expression<Int>("userId")
    let userEmail = Expression<String>("userEmail")
    let placeId = Expression<String>("PlaceId")
    let startHour = Expression<Int>("startHour")
    let startMinute = Expression<Int>("startMinute")
    let endHour = Expression<Int>("endHour")
    let endMin = Expression<Int>("endMin")

    let candyTable = Table("candyTable")
    let candyId = Expression<Int>("candyId")
    let candyName = Expression<String>("candyName")
    
    let userCandyMap = Table("userToCandy")
    let uid = Expression<Int>("uid")
    let cid = Expression<Int>("cid")
    
    let candyTrie = Table("candyTrie")
    let candyPrefix = Expression<String>("candyPrefix")
    let fullName = Expression<String>("fullName")
    init(){
        do {
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileURL = documentDirectory.appendingPathComponent("users").appendingPathComponent("sqlite3")
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            let database = try Connection("\(path)/db.sqlite3")
            self.database = database
            try database.run(self.usersTable.create { (table) in
                table.column(self.userId, primaryKey: true)
                table.column(self.userEmail, unique: true)
                table.column(self.startHour)
                table.column(self.startMinute)
                table.column(self.endMin)
                table.column(self.endHour)

            })
            try database.run(self.candyTable.create { (table) in
                table.column(self.candyId, primaryKey: true)
                table.column(self.candyName, unique: true)
            })
            try database.run(self.userCandyMap.create { (table) in
                table.column(self.uid)
                table.column(self.cid)
            })
            try database.run(self.candyTrie.create { (table) in
                table.column(self.candyPrefix)
                table.column(self.fullName)
            })
        }catch{
            print(error)
        }
        candies = ["Skittles", "M&Ms", "Twix", "Snickers", "Almond Joy", "Mystery", "Starbursts", "Sour Patch", "Sour Gummies", "Swedish Fish"]
        for candy in candies {
            addCandy(candy: candy)
        }
    }
    //Removed due to SQLite
//    public func addCandy(candy: String){
//        var substr = ""
//        for char in candy {
//
//            substr.append(char)
//            if dictionary[substr] != nil {
//                dictionary[substr]?.append(candy)
//            } else {
//                dictionary[substr] = ["\(candy)"]
//            }
//        }
//    }
    public func addCandy(candy: String){
        do{
            if (try database.pluck(candyTable.filter (candyName == candy))) != nil {
                return
            }
            try database.run(candyTable.insert(candyName <- candy))
        }catch {
            print(error)
        }
        var substr = ""
        for char in candy {
            substr.append(char)
            do{
                try database.run(candyTrie.insert(candyPrefix <- substr, fullName <- candy))
            }catch {
                print(error)
            }
        }
        
    }
    public func addUser (user: UserProfile){
        
        do{
            let row = try database.run(usersTable.insert(userEmail <- user.email, placeId <- user.placeId!, startHour <- user.startHour, startMinute <- user.startMin, endHour <- user.endHour, endMin <- user.endMin))
            for c in user.candies {
                let query = candyTable.filter(candyName == c)
                var candyRow: Int!
                for searchCandy in try database.prepare(query) {
                   candyRow = searchCandy[candyId]
                }
                try database.run(userCandyMap.insert(uid <- (Int)(row), cid <- candyRow))
            }
        }catch {
            print(error)
        }
        
    }
    
    public func getUser(email: String ) -> UserProfile{
        do{
            var retUser = UserProfile(emailAddress: email)
            let query = candyTable.filter(userEmail == email)
            var userRow: Int!
            for user in try database.prepare(query) {
                retUser.setStart(hour: user[startHour], min: user[startMinute])
                retUser.setEnd(hour: user[endHour], min: user[endMin])
                retUser.setPlaceId(id: user[placeId])
                userRow = user[userId]
            }
            let candyQuery = userCandyMap.filter(uid == userRow)
            for candy in try database.prepare(candyQuery) {
                let getCandy = candyTable.filter(candyId == candy[cid])
                for addCandy in try database.prepare(getCandy){
                    retUser.addCandy(candy: addCandy[candyName])
                }
            }
            return retUser
        }catch{
            print(error)
        }
        
        return UserProfile(emailAddress: "")
    }
    //Removed when adding SQLite
//    public func top(substr: String, row: Int) -> String{
//        if dictionary[substr] == nil{
//            return ""
//        }
//        if row >= dictionary[substr]!.count {
//            return ""
//        }
//        return dictionary[substr]![row]
//    }
    public func top(substr: String) -> [String]{
        var retval = ["","","","",""]
        do {
            var ind = 0
            for candyRow in try database.prepare(candyTrie.filter(candyPrefix == substr)){
                retval[ind] = candyRow[fullName]
                ind += 1
                if ind == retval.count {
                    break
                }
            }
        }catch{
            print(error)
        }
        return retval
    }
}
