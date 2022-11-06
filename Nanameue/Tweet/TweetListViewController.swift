//
//  TweetListViewController.swift
//  Nanameue
//
//  Created by Stanley Lim on 25/10/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class TweetListViewController: UITableViewController {
    
    private let currentUser: User
    
    private let tweetCellIdentifier = "TweetCellTableViewCell"
    
    private var tweets: [Tweet] = []
    private var tweetsListener: ListenerRegistration?
    
    private let database = Firestore.firestore()
    private var reference: CollectionReference {
        return database.collection("tweets")
    }
    private let storage = Storage.storage().reference()
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(style: .plain)
        title = "TweetList.NavBar.Title".localized()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        clearsSelectionOnViewWillAppear = true
        tableView.register(UINib(nibName: tweetCellIdentifier, bundle: nil), forCellReuseIdentifier: tweetCellIdentifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addButtonPressed))
        listenToTweets()
    }
    
    private func listenToTweets() {
        
        tweetsListener = reference.addSnapshotListener { [weak self] querySnapshot, error in
            guard let self = self else { return }
            guard let snapshot = querySnapshot else {
                print(error?.localizedDescription ?? "Error.Message.Empty".localized())
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func save(_ tweet: Tweet) {
        reference.addDocument(data: tweet.representation) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if self.tweets.count > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
    private func sendPhoto(from tweet: Tweet) {
        uploadImage(from: tweet) { [weak self] url in
            guard let self = self else { return }
            guard let url = url else {
                return
            }
            var tweet = tweet
            tweet.downloadURL = url
            
            self.save(tweet)
            self.tableView.reloadData()
            
        }
    }
    
    private func uploadImage(
        from tweet: Tweet,
        completion: @escaping (URL?) -> Void
    ) {
        guard
            let scaledImage = tweet.image?.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4)
        else {
            return completion(nil)
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let imageReference = storage.child("\(imageName)")
        imageReference.putData(data, metadata: metadata) { _, _ in
            imageReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, _ in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    @objc private func addButtonPressed() {
        let vc = ComposeViewController()
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    private func createTweet(_ tweet: Tweet) {
        if let _ = tweet.image {
            sendPhoto(from: tweet)
        } else {
            save(tweet)
        }
        
        tableView.reloadData()
        
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var tweet = Tweet(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            if let url = tweet.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard
                        let self = self,
                        let image = image
                    else {
                        return
                    }
                    tweet.image = image
                    self.addTweetToTable(tweet)
                }
            } else {
                addTweetToTable(tweet)
            }
        default:
            break
        }
    }
    
    private func addTweetToTable(_ tweet: Tweet) {
        if tweets.contains(tweet) {
            return
        }
        
        tweets.insert(tweet, at: 0)
        tweets.sort(by: >)
        
        guard let index = tweets.firstIndex(of: tweet) else {
            return
        }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    @objc private func moreButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(
          title: nil,
          message: nil,
          preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(
          title: "Alert.Delete.Button.Title".localized(),
          style: .destructive) { [weak self] _ in
              guard let self = self, let id = self.tweets[sender.tag].id else { return }
              self.reference.document(id).delete { [weak self] error in
                  guard let self = self else { return }
                  if let tweet = self.tweets.first(where: { $0.id == id }), let index = self.tweets.firstIndex(of: tweet) {
                      self.tweets.remove(at: index)
                  }
                  self.tableView.reloadData()
                  if let error = error {
                      print(error.localizedDescription)
                  }
              }
        }
        let cancelAction = UIAlertAction(title: "Alert.Cancel.Button.Title".localized(), style: .cancel)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - TableViewDelegate
extension TweetListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tweetCellIdentifier, for: indexPath) as! TweetCellTableViewCell
        cell.usernameLabel.text = tweets[indexPath.row].userId
        cell.moreButton.isHidden = tweets[indexPath.row].userId != cell.usernameLabel.text
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addTarget(self, action: #selector(moreButtonPressed(sender:)), for: .touchUpInside)
        cell.tweetTextLabel.text = tweets[indexPath.row].text
        cell.tweetImageView.image = tweets[indexPath.row].image
        cell.tweetImageView.isHidden = cell.tweetImageView.image == nil
        return cell
    }
}

extension TweetListViewController: ComposeViewControllerDelegate {
    func composeViewController(_ controller: ComposeViewController, didFinishAdding tweet: Tweet) {
        createTweet(tweet)
    }
    
}
