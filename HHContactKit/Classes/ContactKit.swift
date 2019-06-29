//
//  ContactKit.swift
//  PhoneKit_Example
//
//  Created by ios on 2019/6/26.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Contacts
import UIKit
public typealias HandleContactsBlock = (_ contacts: [Contact]) -> Void
public typealias InsertContactsBlock = (_ result: Int) -> Void
public typealias UpdateContactBlock = (Bool) -> Void
@available(iOS 10.0, *)
public class ContactKit {
    var group: DispatchGroup?
    var contacts: [Contact] = []
    /// 单例
    public static var sharedInstance: ContactKit {
        struct Static {
            static let instance: ContactKit = ContactKit()
        }
        return Static.instance
    }
    
    /// 获取通讯录
    ///
    /// - Parameter handleContactssBlock: 
    public static func query(_ handleContactssBlock: @escaping HandleContactsBlock) {
        if ContactKit.sharedInstance.contacts.count != 0 {
            // 已获取直接返回
            handleContactssBlock(ContactKit.sharedInstance.contacts)
            return
        }
        CNContactStore.authorizeToContaces { result in
            guard result else {
                return
            }
            ContactKit.queryContacts(handleContactssBlock)
        }
    }
    
    /// 插入联系人
    ///
    /// - Parameters:
    ///   - contacts: [Contact]
    ///   - insertContactsBlock: 
    public static func insert(contacts: [Contact], _ insertContactsBlock: @escaping InsertContactsBlock) {
        CNContactStore.authorizeToContaces { result in
            guard result else {
                return
            }
            ContactKit.insertContacts(contacts: contacts, insertContactsBlock)
        }
    }
}

