
//

import Foundation

enum NetworkError: String, Error {
    case unableToCompleteNetworkCall = "Unable To Complete the network request. Check your internet"
    case invalidResponse = "Invalid Response from the server. Check the location and try again."
    case invalidData = "Data returned was not valid."
    
}
