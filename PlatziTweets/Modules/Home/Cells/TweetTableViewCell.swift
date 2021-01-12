//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by Jose Octavio on 15/08/20.
//  Copyright © 2020 Jose Octavio. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
// MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    //Nota importante
//    Las celdas nunca deben invocar viewcontrollers
    @IBAction func openVideoAction() {
        guard let videoUrl = videoUrl else{
            return
        }
            needsToShowVideo?(videoUrl)
    }
    
    // MARK - Properties
    private var videoUrl: URL?
    
    var needsToShowVideo : ((_ url: URL) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post: Post) {
        
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        if post.hasImage {
//            configurar imagen
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl))
            
        }else {
            tweetImageView.isHidden = true
            
        }
        if post.hasVideo{
            videoButton.isHidden = false
        }
        else{
            videoButton.isHidden = true
        }
        videoUrl = URL(string: post.videoUrl)
    }
    
    
}
