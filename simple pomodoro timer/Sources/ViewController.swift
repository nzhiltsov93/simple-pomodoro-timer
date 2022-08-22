import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    var isWorkTime: Bool = false
    var isStarted: Bool = false
    var isPaused = true
    
    var duration: Double = 25000
    var timer = Timer()
    
    let playButton = UIImage(systemName: "play")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50))
    let pauseButton = UIImage(systemName: "pause")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50))
    
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        return shapeLayer
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 75)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setImage(playButton, for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

