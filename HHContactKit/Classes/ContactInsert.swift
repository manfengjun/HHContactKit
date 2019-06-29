//
//  ContactInsert.swift
//  HHContactKit
//
//  Created by ios on 2019/6/27.
//

import UIKit
import Contacts
// MARK: - 增加联系人
@available(iOS 10.0, *)
extension ContactKit {
    
    /// 批量插入联系人
    ///
    /// - Parameters:
    ///   - contacts:
    ///   - insertContactsBlock:
    static func insertContacts(contacts: [Contact],  _ insertContactsBlock: @escaping InsertContactsBlock) {
        // 创建通讯录对象
        let store = CNContactStore()
        // 创建CNMutableContact类型的实例
        let contactToAdd = CNMutableContact()
        let group = DispatchGroup()
        var result: Int = 0
        contacts.forEach {
            group.enter()
            // 设置姓名
            if let name = $0.name {
                contactToAdd.givenName = name
            }
            if let company =  $0.company {
                contactToAdd.organizationName = company
            }
            // 设置电话
            contactToAdd.phoneNumbers =  $0.mobile_phones.map {
                let mobileNumber = CNPhoneNumber(stringValue: $0)
                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile,
                                                 value: mobileNumber)
                return mobileValue
            }
            // 添加联系人请求
            let saveRequest = CNSaveRequest()
            saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
            do {
                // 写入联系人
                try store.execute(saveRequest)
                group.leave()
                result = result + 1;
            } catch {
                print(error)
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            insertContactsBlock(result)
        }
    }
}

