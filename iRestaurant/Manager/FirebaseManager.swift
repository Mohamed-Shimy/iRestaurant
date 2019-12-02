//
//  FirebaseManager.swift
//  iRestaurant
//
//  Created by MacOS Mojave on 2 November, 2019.
//  Copyright © 2019 Shemy. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager: NSObject
{

    public var viewController: UIViewController!
    public var email: String!
    public var password: String!
    public var userName: String!
    public var image: UIImage!
    public var uid: String!
    public var url: URL!
    public var nid: String!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    // MARK: - init
    
    init(email: String, password: String, viewController: UIViewController, completion: @escaping((_ login:Bool?, _ error: Error?)->()))
    {
        super.init()
        self.email = email
        self.password = password
        self.viewController = viewController
        self.Login(){login, error in completion(login, error)}
    }
    
    init(userName: String, email: String, password: String, image: UIImage, completion: @escaping((_ error: Error?)->()))
    {
        super.init()
        self.email = email
        self.userName = userName
        self.password = password
        self.image = image
        self.SignUp(){error in completion(error)}
    }
    
    
     // MARK: - Authentication
    
    public func Login(completion: @escaping((_ login:Bool?, _ error: Error?)->()))
    {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                completion(false, error)
            }else {
                self.userName = authDataResult?.user.displayName
                self.uid = authDataResult?.user.uid
                self.nid = self.getID(name: self.userName, id: self.uid!)
                self.url = authDataResult?.user.photoURL
                let storageRef = self.storage.reference(forURL: self.url.absoluteString)
                
                self.download(storageReference: storageRef) { image, error in
                    if error == nil{
                        self.image = image
                        completion(true, nil)
                    }else{
                        completion(false, error)
                    }
                }
            }
        }
    }

    public func SignUp(completion: @escaping((_ error: Error?)->()))
    {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if authDataResult == nil || error != nil
            {
                completion(error)
                return
            }
            self.uid = authDataResult?.user.uid
            let name = self.userName.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            self.nid = self.getID(name: self.userName, id: self.uid!)
            let storageRef = self.storage.reference().child("user/\(self.nid!)/\(name)")
            self.upload(self.image, storageRef: storageRef)
            {   url, error in
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = self.userName
                changeRequest?.photoURL = url
                self.url = url
                changeRequest?.commitChanges{error in
                    completion(error)
                }
            }
            
        }
    }
    
    public func SignUp(userName: String, email: String, password: String, image: UIImage, completion: @escaping((_ error: Error?)->()))
    {
        self.email = email
        self.userName = userName
        self.password = password
        self.image = image
        self.SignUp(){error in completion(error)}
    }
    
    public func SignOut(completion: @escaping((_ error: Error?)->()))
    {
        do{
            try! Auth.auth().signOut()
             completion(nil)
        }catch let error{
            completion(error)
        }
    }
    
    
     // MARK: - Manage Database
    
    public func insert(restaurant: Restaurant, completion: @escaping((_ restaurants:Restaurant?, _ error: Error?)->()))
    {
        let data: [String: Any] = [
            "Name": restaurant.name,
            "Type": restaurant.type,
            "Location": restaurant.location,
            "Phone": restaurant.phone,
            "IsVisited": restaurant.isVisited,
            "IsFavorite": restaurant.isFavorite,
            "Rating": restaurant.rating]
        
        var doc: DocumentReference!
        
        doc = db.collection(self.nid!).addDocument(data: data, completion: {error in
            if error != nil { completion(nil, error) }
            else
            {
                self.updateImageAfterInserting(doc: doc, restaurant: restaurant, completion: { (restaurant, error) in                  completion(restaurant, error) })
            }
        })
    }
    
    func updateImageAfterInserting(doc: DocumentReference, restaurant: Restaurant, completion: @escaping((_ restaurants:Restaurant?, _ error: Error?)->()))
    {
        self.update(restaurantID: doc.documentID, newValue: ["ID": doc.documentID], completion:
            { error in
                if error != nil{ completion(nil, error)}
                else
                {
                    restaurant.ID = doc.documentID
                    let ref = self.storage.reference(withPath: "user/\(self.nid!)/restaurants")
                    
                    self.upload(restaurant.image, storageRef: ref.child(doc.documentID), completion:
                        { url, error in
                            if error != nil{ completion(nil, error) }
                            self.update(restaurantID: restaurant.ID, newValue: ["Image": (url?.absoluteString)!], completion: { error in
                                restaurant.imagePath = (url?.absoluteString)!
                                completion(restaurant, error) })
                    })
                    
                }
        })
    }
    
  
    public func update(restaurantID: String, newValue: [String: Any], completion: @escaping((_ error:Error?)->()))
    {
        db.collection(nid!).document("\(restaurantID)").setData(newValue, merge: true, completion: {error in  completion(error) })
    }
    
    public func updateImage(restaurantID: String, oldImagePath: String, image: UIImage, completion: @escaping((_ url: String?, _ error:Error?)->()))
    {
        self.deleteFile(filePath: oldImagePath, completion: {error in })
        
        self.update(restaurantID: restaurantID, newValue: ["Image":  FieldValue.delete()], completion: { (error) in })
        
        let ref = self.storage.reference(withPath: "user/\(self.nid!)/restaurants")
        self.upload(image, storageRef: ref, completion: {  url, error in
            if error == nil { self.update(restaurantID: restaurantID, newValue: ["Image": (url?.absoluteString)!], completion: { error in })}
            completion(url?.absoluteString, error)
        })
    }
    
    public func delete(retaurantID: String, completion: @escaping((_ error:Error?)->()))
    {
        db.collection(nid!).document("\(retaurantID)").delete() { error in   completion(error) }
    }
    
    public func deleteFile(filePath: String, completion: @escaping((_ error:Error?)->()))
    {
        let storageRef = storage.reference(withPath: filePath)
        //Removes image from storage
        storageRef.delete { error in  completion(error) }
    }
    
    public func getRestaurants(field: String, isEqualTo: Any, completion: @escaping((_ restaurants:[Restaurant]?, _ error: Error?)->()))
    {
        db.collection(self.nid!).whereField(field, isEqualTo: isEqualTo).getDocuments(completion: { (querySnapshot, error) in
            if error != nil {
                completion([], error)
            } else {
                let rs = self.castDicRestaurant(queryDocument: querySnapshot!)
                completion(rs, nil)
            }
        })
    }
    
    public func getAllRestaurants(completion: @escaping((_ restaurants:[Restaurant]?, _ error: Error?)->()))
    {
        db.collection(self.nid!).order(by: "Name", descending: false).getDocuments( completion: { (querySnapshot, error) in
            if error != nil {
                completion([], error)
            } else {
                completion(self.castDicRestaurant(queryDocument: querySnapshot!), nil)
            }
        })
    }

    
     // MARK: - Help
    
    private func castDicRestaurant(queryDocument: QuerySnapshot) -> [Restaurant]
    {
        var restaurants: [Restaurant] = []
        
        for doc in queryDocument.documents
        {
            let id = doc.data()["ID"] as! String
            let name = doc.data()["Name"] as! String
            let type = doc.data()["Type"] as! String
            let location = doc.data()["Location"] as! String
            let phone = doc.data()["Phone"] as! String
            let isVisited = doc.data()["IsVisited"] as! Bool
            let isFavorite = doc.data()["IsFavorite"] as! Bool
            let imagePath = doc.data()["Image"] as? String
            let rating = doc.data()["Rating"] as! Float
            let res = Restaurant(ID: id, name: name, type: type, location: location, phone: phone, isVisited: isVisited, isFavorite: isFavorite, rating: rating, imagePath: imagePath ?? "", image: nil)

            restaurants.append(res)
        }
        
        return restaurants
    }
    
    func getID(name: String, id: String) -> String
    {
        return "\(name.replacingOccurrences(of: " ", with: "_", options: .literal, range: nil))_\(id)"
    }
    
    func download(storageReference: StorageReference, completion: @escaping((_ image:UIImage?, _ error: Error?)->()))
    {
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if data != nil{
                completion( UIImage(data: data!)!, error)
            } else {completion(nil, error)}
        }
    }
    
    func upload(_ image: UIImage, storageRef: StorageReference, completion: @escaping((_ url:URL?, _ error: Error?)->()))
    {
        //let storageRef = Storage.storage().reference().child("user/\(uid)/\(name)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(image.jpegData(compressionQuality: 80.0)!, metadata: metaData)
        {
            metaData,error in
            if error == nil && metaData != nil
            {
                storageRef.downloadURL(completion: { url, error in
                    error == nil ? completion(url, nil) : completion(nil, error)
                })
            }
            else
            {
                completion(nil, error)
            }
        }
    }
    
}
