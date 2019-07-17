//
//  Networking.swift
//

import Foundation

struct Networking {
    
    func performNetworkTask<T: Codable>(endpoint: APIServices,
                                        type: T.Type?,
                                        completion: ((_ response: T?) -> Void)?,
                                        errorCompletion: ((_ messages: String?) -> Void)?
                                        ) {
        
        let urlString = "\(BASE_URL)\(endpoint.path)"
        
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = endpoint.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(endpoint.method)
        if (endpoint.method == "POST" || endpoint.method == "PUT"){
            let jsonData = try? JSONSerialization.data(withJSONObject:endpoint.parameters)
            request.httpBody = jsonData
        }
        
        let urlSession = URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let _ = error {
                return
            }
            guard let data = data else {
                return
            }
            
            //let responseData = String(data: data, encoding: String.Encoding.utf8)
            //print(responseData!)
            
            let response = Response(results: data)
            
            var messages = ""
            
            guard let decoded = response.decode(type!) else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    messages = json["errors"] as? String ?? "Something Wrong"
                } catch let error as NSError {
                    print(error)
                    messages = "Something Wrong"
                }
                return (errorCompletion?(messages))!
            }
            
            completion?(decoded)
        }
        
        urlSession.resume()
    }
}
