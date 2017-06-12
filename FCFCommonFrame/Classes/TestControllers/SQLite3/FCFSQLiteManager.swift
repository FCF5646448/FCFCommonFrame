//
//  FCFSQLiteManager.swift
//  FCFCommonFrame
//
//  Created by 冯才凡 on 2017/6/2.
//  Copyright © 2017年 com.fcf. All rights reserved.
//

import UIKit

//数据库单例
class FCFSQLiteManager {
/**/
    //数据库单例
    //static let shareInstance = FCFSQLiteManager()
    //private init() {}
    
    //数据库对象
    var db:OpaquePointer? = nil
    //数据库路径
    let sqlitePath:String
    
    init?(path:String) {
        sqlitePath = path
        db = self.openDatabase(path: sqlitePath)
        if db == nil {
            return nil
        }
    }
    
    //创建一个数据库文件，首先需要一个文件名，然后通过文件名得到地址，再通过地址去创建数据库文件
    func openDatabase(path:String)->OpaquePointer? {
        var connectdb:OpaquePointer? = nil
        if sqlite3_open(path, &connectdb) == SQLITE_OK { 
            print("Successfully opened database\(path)")
            return connectdb!
        }else{
            print("Unable to database")
            return nil
        }
    }
    
    //创建表
    func creatTable(_ tableName:String,columsInfo:[String])->Bool{
        let sql = "create table if not exists \(tableName)" + "(\(columsInfo.joined(separator: ",")))"
        if sqlite3_exec(self.db, sql.cString(using: String.Encoding.utf8), nil, nil, nil) == SQLITE_OK {
            return true
        }
        return false
    }
    
    //插入资料
    func insert(_ tableName:String,rowInfo:[String:String])->Bool{
        var statement:OpaquePointer? = nil
        let sql = "insert into \(tableName) " + "(\(rowInfo.keys.joined(separator: ","))) " + "values (\(rowInfo.values.joined(separator: ",")))"
        if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }else{
            print(sqlite3_errmsg(statement))
        }
        
        return false
    }
    
    //查找
    func fetch(_ tabelName:String,cond:String?,order:String?)->OpaquePointer{
        var statement:OpaquePointer? = nil
        var sql = "select * from \(tabelName)"
        if let condition = cond {
            sql += " where \(condition)"
        }
        if let orderBy = order {
            sql += " order by \(orderBy)"
        }
        sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil)
        return statement!
    }
    
    //更新
    func update(_ tableName:String,cond:String?,rowInfo:[String:String])->Bool {
        var statement:OpaquePointer? = nil
        var sql = "update \(tableName) set "
        var info:[String] = []
        for (k,v) in rowInfo {
            info.append("\(k) = \(v)")
        }
        sql += info.joined(separator: ",")
        if let condition = cond {
            sql += " where \(condition)"
        }
        if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        return false
    }
    
    //删除
    func delete(_ tableName:String,cond:String?)->Bool{
        var statement:OpaquePointer? = nil
        var sql = "delete from \(tableName)"
        if let condition = cond {
            sql += " where \(condition)"
        }
        if sqlite3_prepare_v2(self.db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return true
            }
            sqlite3_finalize(statement)
        }
        return false
    }
}
