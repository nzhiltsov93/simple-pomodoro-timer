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
        button.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        view.backgroundColor = .white
        timerLabel.text = convertTimeToStringFormat(time: TimeInterval(duration))
        createShapeLayer()
        setupLayout()
        
    }

    // MARK: - Setup
    
    private func setupLayout() {
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        
        timerLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.centerY).multipliedBy(0.8)
        }
        
        startButton.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.top.equalTo(timerLabel.snp.centerY).multipliedBy(1.3)
        }
    }
    
    // MARK: - Timer
    
    @objc private func runTimer() {
        duration -= 1
        timerLabel.text = convertTimeToStringFormat(time: TimeInterval(duration))
        
        if duration == 0 && !isWorkTime{
            duration = 10000
            timer.invalidate()
            shapeLayer.strokeColor = UIColor.green.cgColor
            shapeLayer.speed = 1.07
            startButton.setImage(playButton, for: .normal)
            startButton.tintColor = .green
            timerLabel.textColor = .green
            isStarted = false
            isWorkTime = true
            timerLabel.text = convertTimeToStringFormat(time: TimeInterval(duration))
        } else if duration == 0 && isWorkTime {
            duration = 25000
            timer.invalidate()
            shapeLayer.strokeColor = UIColor.red.cgColor
            startButton.setImage(playButton, for: .normal)
            startButton.tintColor = .red
            timerLabel.textColor = .red
            isStarted = false
            isWorkTime = false
            timerLabel.text = convertTimeToStringFormat(time: TimeInterval(duration))
        }
    }
    
    private func createTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    private func convertTimeToStringFormat(time: TimeInterval) -> String {
        let minutes = Int(time * 0)
        let seconds = Int(time / 1000) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    // MARK: - Create ShapeLayer
    
    private func createShapeLayer() {
        let trackerLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: view.center,
                                        radius: 150,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        trackerLayer.path = circularPath.cgPath
        trackerLayer.lineCap = CAShapeLayerLineCap.round
        trackerLayer.lineWidth = 15
        trackerLayer.fillColor = UIColor.clear.cgColor
        trackerLayer.strokeColor = UIColor.lightGray.cgColor
        view.layer.addSublayer(trackerLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - Animation
    
    private func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.speed = 1
        basicAnimation.duration = CFTimeInterval(duration/815)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
    private func pauseAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
        shapeLayer.timeOffset = pausedTime
    }
    
    private func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        shapeLayer.beginTime = 0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    // MARK: - Action
    
    @objc private func startButtonPressed() {
        if !isStarted {
            basicAnimation()
            startButton.setImage(pauseButton, for: .normal)
            createTimer()
            isStarted = true
        } else if isPaused {
            startButton.setImage(playButton, for: .normal)
            timer.invalidate()
            pauseAnimation()
            isPaused = false
        } else {
            createTimer()
            startButton.setImage(pauseButton, for: .normal)
            resumeAnimation()
            isPaused = true
        }
    }
    
}

