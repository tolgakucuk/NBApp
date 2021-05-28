
import UIKit
import Alamofire

class PlayerDetailVC: UIViewController {
    
    //PlayersVC sayfasından gelen veriler
    var playerID: Int = 0
    var playerAvatarImageString: String = ""
    
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerAvatarImageView: UIImageView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var playerNameLabel: UILabel!
    
    @IBOutlet weak var ptsLabel: UILabel!
    @IBOutlet weak var blkLabel: UILabel!
    @IBOutlet weak var stlLabel: UILabel!
    @IBOutlet weak var astLabel: UILabel!
    @IBOutlet weak var rebLabel: UILabel!
    @IBOutlet weak var ftmLabel: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var regularButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        //default olarak sayfada career regular season apisine istek atılıp gelen verilerin gösterilmesi.
        getRegularSeason { (stats) in
            if stats != nil {
                self.playerNumberLabel.text = "\(Int.random(in: 0..<99))" //random forma numarası
                
                self.ptsLabel.text = "\(stats!.pts_per_game)"
                self.blkLabel.text = "\(stats!.blk_per_game)"
                self.stlLabel.text = "\(stats!.stl_per_game)"
                
                self.astLabel.text = "\(stats!.ast_per_game)"
                self.rebLabel.text = "\(stats!.reb_per_game)"
                self.ftmLabel.text = "\(stats!.ftm_per_game)"
            }
        }
        
        
    }
    
    //Player details sayfası çağrıldığıdna görünümün ayarlanması; viewların köşelerini değiştirme, gölgeleme ekleme, yazıların görselin altına gelmesi
    func setupLayout() {
        playerAvatarImageView.image = UIImage(named: playerAvatarImageString)
        
        firstView.layer.cornerRadius = 10
        firstView.addShadow(color: .darkGray, opacity: 0.8, radius: 3.0)
        
        secondView.layer.cornerRadius = 10
        secondView.addShadow(color: .darkGray, opacity: 0.8, radius: 3.0)
        
        postButton.centerVertically()
        regularButton.centerVertically()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //GetCareerPostSeason apisine istek atılmasını sağlayan fonksiyon.
    func getCareerPostSeason(completion: @escaping((PlayerStats?) -> Void)) {
        
        let loadingIndicator = UIViewController.displaySpinner(onView: self.view)
        self.view.addSubview(loadingIndicator)
        
        Network.shared.get("\(URLs.BASE_URL)/\(Endpoints.per_game_career_post_season)/\(playerID)", params: nil) { (jsonData, code, err) in
            if err == nil {
                guard let data = jsonData else {return}
                do {
                    let playerStats = try JSONDecoder().decode(PlayerStats.self, from: data)
                    completion(playerStats)
                } catch let error {
                    print(error)
                }
                
                UIViewController.removeSpinner(spinner: loadingIndicator)
            }
        }
        
    }
    
    //GetCareerRegularSeason apisine istek atılmasını sağlayan fonksiyon.
    func getRegularSeason(completion: @escaping((PlayerStats?) -> Void)) {
        
        let loadingIndicator = UIViewController.displaySpinner(onView: self.view)
        self.view.addSubview(loadingIndicator)
        
        Network.shared.get("\(URLs.BASE_URL)/\(Endpoints.per_game_regular_season)/\(playerID)", params: nil) { (jsonData, code, err) in
            if err == nil {
                print(jsonData ?? "")
                
                guard let data = jsonData else {return}
                do {
                    let playerStats = try JSONDecoder().decode(PlayerStats.self, from: data)
                    completion(playerStats)
                } catch let error {
                    print(error)
                }
                
                UIViewController.removeSpinner(spinner: loadingIndicator)
            }
        }
        
    }
    
    //Post butonuna tıklanıldığında getCareerPostSeason methoduna çağırıp gelen verilerin ilgili labellara yazdırılması.
    @IBAction func postButtonPressed(_ sender: Any) {
        postButton.setImage(UIImage(systemName: "p.circle.fill"), for: .normal)
        regularButton.setImage(UIImage(systemName: "r.circle"), for: .normal)
        
        getCareerPostSeason { (stats) in
            if stats != nil {

                
                self.ptsLabel.text = "\(stats!.pts_per_game)"
                self.blkLabel.text = "\(stats!.blk_per_game)"
                self.stlLabel.text = "\(stats!.stl_per_game)"
                
                self.astLabel.text = "\(stats!.ast_per_game)"
                self.rebLabel.text = "\(stats!.reb_per_game)"
                self.ftmLabel.text = "\(stats!.ftm_per_game)"
            }
        }
        
    }
    
    //Regular butonuna tıklanıldığında getCareerRegularSeason methoduna çağırıp gelen verilerin ilgili labellara yazdırılması.
    @IBAction func regularButtonPressed(_ sender: Any) {
        postButton.setImage(UIImage(systemName: "p.circle"), for: .normal)
        regularButton.setImage(UIImage(systemName: "r.circle.fill"), for: .normal)
        
        getRegularSeason { (stats) in
            if stats != nil {
                
                self.ptsLabel.text = "\(stats!.pts_per_game)"
                self.blkLabel.text = "\(stats!.blk_per_game)"
                self.stlLabel.text = "\(stats!.stl_per_game)"
                
                self.astLabel.text = "\(stats!.ast_per_game)"
                self.rebLabel.text = "\(stats!.reb_per_game)"
                self.ftmLabel.text = "\(stats!.ftm_per_game)"
            }
        }
        
        
    }
    
}
