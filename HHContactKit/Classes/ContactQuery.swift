//
//  ContactQuery.swift
//  HHContactKit
//
//  Created by ios on 2019/6/27.
//

import UIKit
import Contacts
// MARK: - 加载通讯录信息
@available(iOS 10.0, *)
extension ContactKit {
    /// 查询通讯录联系人
    static func queryContacts(_ handleContactssBlock: @escaping HandleContactsBlock) {
        // 获取授权状态
        let status = CNContactStore.authorizationStatus(for: .contacts)
        // 判断当前授权状态
        guard status == .authorized else { return }
        // 创建通讯录对象
        let store = CNContactStore()
        // 获取Fetch,并且指定要获取联系人中的什么属性
        let keys = [CNContactFamilyNameKey,
                    CNContactGivenNameKey,
                    CNContactNicknameKey,
                    CNContactOrganizationNameKey,
                    CNContactJobTitleKey,
                    CNContactDepartmentNameKey,
                    CNContactNoteKey,
                    CNContactPhoneNumbersKey,
                    CNContactEmailAddressesKey,
                    CNContactPostalAddressesKey,
                    CNContactDatesKey,
                    CNContactInstantMessageAddressesKey]
        let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        let group = DispatchGroup()
        do {
            var index: Int = 0
            try store.enumerateContacts(with: request, usingBlock: { (contact, _: UnsafeMutablePointer<ObjCBool>) in
                group.enter()
                convertContact(contact)
                group.leave()
                index = index + 1
            })
            group.notify(queue: DispatchQueue.main) {
                handleContactssBlock(ContactKit.sharedInstance.contacts)
            }
        } catch {
            print(error)
        }
    }
    
    /// 联系人转换
    ///
    /// - Parameter contact: 
    static func convertContact(_ contact: CNContact) {
        let phones = contact.phoneNumbers.map {
            let value = $0.value.stringValue.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            return value
            }.filter {
            mobile($0)
        }
        if phones.count > 0 {
            var contactInfo = Contact()
            // 获取姓名
            let lastName = contact.familyName
            let firstName = contact.givenName
            contactInfo.name = "\(lastName)\(firstName)"
            
            // 获取公司（组织）
            let organization = contact.organizationName
            contactInfo.company = organization
            
            // 获取电话号码
            contactInfo.mobile_phones = phones as! [String]
            ContactKit.sharedInstance.contacts.append(contactInfo)
        }
    }
    static func mobile(_ text: String) -> Bool {
        do {
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "1[3|5|7|8|][0-9]{9}", options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: text, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, text.count))
            return matches.count > 0
        } catch  {
            return false
        }
    }
}
