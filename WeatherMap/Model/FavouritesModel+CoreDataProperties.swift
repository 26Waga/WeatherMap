
//
//

import Foundation
import CoreData


extension FavouritesModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritesModel> {
        return NSFetchRequest<FavouritesModel>(entityName: "FavouritesModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}

extension FavouritesModel : Identifiable {

}
