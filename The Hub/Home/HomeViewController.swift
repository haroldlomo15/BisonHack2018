//
//  HomeViewController.swift
//  The Hub
//
//  Created by Harold  on 3/31/18.
//  Copyright © 2018 Harold . All rights reserved.
//

import UIKit
import AVFoundation
import WebKit
import Firebase
import PCLBlurEffectAlert
import AlamofireImage

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var musics: [[String:Any]] = [[:]]
    
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
     //   fetchMovieData()
       
        fetchMusic()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareMovie.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let musicInfo = shareMovie[indexPath.item]
        cell.artistLabel.text = musicInfo.artist
        cell.titleLabel.text = musicInfo.title
        cell.usernameLabel.text = musicInfo.username
        cell.timeStampLabel.text = musicInfo.creationDate.timeAgoDisplay()
        
        guard let imageUrl = URL(string: musicInfo.profileImage) else { return cell }
        cell.profileImageView.af_setImage(withURL: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMusic = shareMovie[indexPath.item]
        
        
        let musicTextInfo = selectedMusic.artist + " " + selectedMusic.title
        let musicInfo = musicTextInfo.replacingOccurrences(of: " ", with: "+")
        
        fetchMusicData(musicText: musicInfo)
    }
    
    var shareMovie = [ShareMusic]()
    func fetchMusic() {
        let ref = Database.database().reference().child("music")
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            //  print()
            
            
            let shareMovie = ShareMusic(dictionary: dictionary)
            //    self.favorites.append(favorite)
            self.shareMovie.insert(shareMovie, at: 0)
            
          
            self.collectionView.reloadData()
            
        }) { (error) in
            print("Failed to fetch ordered posts:", error)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
       
        
        return CGSize(width: width - 20, height: 100)
        
        
    }
    
    
    @IBAction func playDidTapped(_ sender: Any) {
        let info = musics[0]
       // print(info)
        let musicPreview = info["previewUrl"] as? String
        print(musicPreview)
        
        let audioUrl = URL(string: musicPreview!)
        let request = URLRequest(url: audioUrl!)
        webView.load(request)
      
        
    }
    
    
    
    func fetchMusicData(musicText:String) {
        
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(musicText)") else { return }
        
        //  print(url)
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This would run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
       
                let music = dataDictionary["results"] as! [[String:Any]]
                
                
                if music.isEmpty {
                    print("Empty Babbbby")
                    
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.prepare()
                    generator.impactOccurred()
                    
                    let alert = PCLBlurEffectAlert.Controller(title: "Empty", message: "Try selecting less movie categories", effect: UIBlurEffect(style: .light), style: .alert)
                    let alertBtn = PCLBlurEffectAlert.Action(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertBtn)
                    alert.configure(buttonTextColor: [.default: UIColor(red: 58/255, green: 57/255, blue: 42/255, alpha: 1)])
                    
                    alert.configure(cornerRadius: 10.0)
                    alert.configure(backgroundColor: UIColor(red: 58/255, green: 57/255, blue: 42/255, alpha: 1))
                    alert.configure(titleColor: .white)
                    alert.configure(messageColor: .white)
                    alert.configure(buttonBackgroundColor: .white)
                    alert.show()
                } else {
                 //   self.musics = music
                    let info = music[0]
                    // print(info)
                    let musicPreview = info["previewUrl"] as? String
                  //  print(musicPreview)
                    
                    let audioUrl = URL(string: musicPreview!)
                    let request = URLRequest(url: audioUrl!)
                    self.webView.load(request)
                  //  print(self.musics)
                }
                
            }
        }
        
        task.resume()
        
        
    }
    
    
}
