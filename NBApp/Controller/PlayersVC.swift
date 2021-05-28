
import UIKit
import Alamofire

class PlayersVC: UIViewController {
    
    @IBOutlet weak var playersTableView: UITableView!
    var players: [Player] = []
    
    var currentPage : Int = 1
    var loadingStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableview delegation işlemleri
        playersTableView.delegate = self
        playersTableView.dataSource = self
        
        //api'den gelen oyuncuların listelenmesi.
        getPlayers(currentPage: 1) { (players) in
            if players != nil {
                self.players = players!
            }
            self.playersTableView.reloadData()
        }
        
    }
    
    //get_players endpointinden veri çekmemizi sağlayan fonksiyon.
    func getPlayers(currentPage: Int, completion: @escaping(([Player]?) -> Void)) {
        
        let loadingIndicator = UIViewController.displaySpinner(onView: self.view)
        self.view.addSubview(loadingIndicator)
        
        let parameters: Parameters = [
            "is_active": 1, //aktif oyuncuları listeler
            "page": currentPage,
            "per_page": 50 //sayfada kaç oyuncu listelensin
        ]
        
        
        
        Network.shared.get("\(URLs.BASE_URL)/\(Endpoints.get_players)/", params: parameters) { (jsonData, code, err) in
            if err == nil {
                guard let data = jsonData else {return}
                
                do {
                    let players = try JSONDecoder().decode([Player].self, from: data)
                    completion(players)
                } catch let error {
                    print(error)
                }
                UIViewController.removeSpinner(spinner: loadingIndicator)
            }
        }
        
    }
    
    //veri çekerken timeout oluşmaması için scroll aşağıya indiğinde girilen "per_page" değişkeni kadar veri çekmemeizi sağlayan fonksiyon.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height && offsetY > 0 {
            if !loadingStatus {
                currentPage += 1
                loadingStatus = true
                getPlayers(currentPage: currentPage) { (players) in
                    if players != nil {
                        self.players.append(contentsOf: players!)
                        self.playersTableView.reloadData()
                        self.loadingStatus = false
                    }
                }
            }
        }
        
    }
    
}

extension PlayersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerCell
        cell.configureCell()
        cell.playerIDLabel.text = "\(players[indexPath.row].id)"
        cell.playerNameLabel.text = players[indexPath.row].full_name
        return cell
    }
    
    //oyuncuya tıklandığında player details sayfasına gitmemizi sağlayan fonksiyon
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(players[indexPath.row].id)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PlayerDetailVC") as! PlayerDetailVC
        vc.playerID = players[indexPath.row].id
        
        //API'den oyuncu görseli gelmediği için asset içindeki görsellerin gösterilmesi
        vc.playerAvatarImageString = "p-\(indexPath.row % 5)"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

