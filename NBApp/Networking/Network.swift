
import Foundation
import Alamofire

class Network {
    
    static let shared = Network()
    
    //API'den veri çekerken kullanacağımız fonksiyonun yazılması.
    func get(_ url: String, params: Parameters?, completion: @escaping (_ data: Data?, _ statusCode: Int?, _ error: Error?) -> Void) {
        
        AF.session.configuration.timeoutIntervalForRequest = 30.0
        AF.session.configuration.timeoutIntervalForResource = 30.0
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "9a6a5f43d0mshce8ba9de26baec4p1e1cf9jsn1ecc95bd2dd7",             "x-rapidapi-host": "nba-stats4.p.rapidapi.com"
        ]
        
        AF.request(url, method: .get, parameters: params ?? nil, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.data, let statusCode = response.response?.statusCode {
                    completion(data, statusCode, nil)
                }
            case .failure(let error):
                if let statusCode = response.response?.statusCode {
                    print("Error = \(statusCode)")
                    completion(nil, statusCode, error)
                }
            }
        }
        
    }
    
    
    
    
    
    
}
