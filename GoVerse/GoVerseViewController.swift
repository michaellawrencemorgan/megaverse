import UIKit
import Alamofire
import SnapKit
import SwiftyJSON
import NotificationBannerSwift

class GoVerseViewController: UIViewController {
    private var verses: [Verse] = []
    private var images: [UIImage] = []
    private var verseIndex: Int = 0
    private var imageIndex: Int = 0

    private let verseLabel = UILabel()
    private let topicLabel = UILabel()
    private let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadInitialData()
        setupGestures()
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        verseLabel.numberOfLines = 0
        verseLabel.textAlignment = .center
        verseLabel.textColor = .white
        verseLabel.font = UIFont.preferredFont(forTextStyle: .title2)

        topicLabel.textAlignment = .center
        topicLabel.textColor = .white
        topicLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        let stack = UIStackView(arrangedSubviews: [topicLabel, verseLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(view.snp.leading, offset: 16)
            make.trailing.lessThanOrEqualTo(view.snp.trailing, offset: -16)
        }
    }

    private func loadInitialData() {
        // Placeholder: load verses from local JSON or remote API
        // Here we create a couple of sample verses
        verses = [
            Verse(book: "John", chapter: 3, verse: 16, text: "For God so loved the world...", topic: "Love", translation: "NIV"),
            Verse(book: "Psalm", chapter: 23, verse: 1, text: "The Lord is my shepherd...", topic: "Provision", translation: "ESV")
        ]

        // Placeholder images bundled in the app
        images = [UIImage(named: "background1")!, UIImage(named: "background2")!]

        updateUI()
    }

    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            verseIndex = (verseIndex + 1) % verses.count
        case .right:
            verseIndex = (verseIndex - 1 + verses.count) % verses.count
        case .up:
            imageIndex = (imageIndex + 1) % images.count
        case .down:
            imageIndex = (imageIndex - 1 + images.count) % images.count
        default:
            break
        }
        updateUI()
    }

    private func updateUI() {
        guard !verses.isEmpty, !images.isEmpty else { return }
        let verse = verses[verseIndex]
        verseLabel.text = "\(verse.book) \(verse.chapter):\(verse.verse) (\(verse.translation))\n\n\(verse.text)"
        topicLabel.text = verse.topic
        imageView.image = images[imageIndex]
    }

    // Example method to fetch verses from a remote server using Alamofire
    private func fetchVerses(from url: URL) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.verses = json.arrayValue.compactMap { item in
                    guard let book = item["book"].string,
                          let chapter = item["chapter"].int,
                          let verseNum = item["verse"].int,
                          let text = item["text"].string,
                          let topic = item["topic"].string,
                          let translation = item["translation"].string else {
                        return nil
                    }
                    return Verse(book: book, chapter: chapter, verse: verseNum, text: text, topic: topic, translation: translation)
                }
                self.updateUI()
            case .failure(let error):
                NotificationBanner(title: "Error", subtitle: error.localizedDescription, style: .danger).show()
            }
        }
    }
}
