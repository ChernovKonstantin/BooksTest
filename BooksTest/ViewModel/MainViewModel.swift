//
//  MainViewModel.swift
//  BooksTest
//
//  Created by Chernov Kostiantyn on 22.02.2024.
//

import FirebaseRemoteConfig

class MainViewModel: ObservableObject {
    
    @Published var books: MainModel?
    
    func startFetching() async {
        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        do {
            let config = try await remoteConfig.fetchAndActivate()
            switch config {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                let jsonData = remoteConfig.configValue(forKey: "json_data").dataValue
                let detailsCarousel = remoteConfig.configValue(forKey: "details_carousel").dataValue
                let decodedJsonData: JsonDataModel? = try decodeFetchedData(from: jsonData)
                let decodedDetailsCarousel: CarouselDataModel? = try decodeFetchedData(from: detailsCarousel)
                guard let decodedJsonData, let decodedDetailsCarousel else { return }
                DispatchQueue.main.async { [self] in
                    books = MainModel(jsonData: decodedJsonData, detailsCarousel: decodedDetailsCarousel)
                }
            default:
                print("Error activating remote configuration")
            }
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
        }
    }
    
    func decodeFetchedData<DataType: Decodable>(from jsonData: Data) throws -> DataType? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DataType.self, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            throw error
        }
    }
}
