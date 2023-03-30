
//

import Foundation


class NetworkService {
    
    static let shared = NetworkService()
    
    let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"
    
    
    func getForecast(latitude: Double, longitude: Double, completed: @escaping(Result<WeatherData, NetworkError>) -> Void) {
        
        let endpoint = baseUrl + "?lat=\(latitude)&lon=\(longitude)&exclude=minutely,hourly,alerts&appid=\(Keys.appId)&units=metric"
        
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidResponse))
             return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            if let _ = error {
                completed(.failure(.unableToCompleteNetworkCall))
                return
            }
            
            guard let response = response else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                
                let weather = try decoder.decode(WeatherData.self, from: data)
                completed(.success(weather))
                
            } catch {
                completed(.failure(.invalidData))
            }


        }
        
        task.resume()
        
    }
    
    
}
