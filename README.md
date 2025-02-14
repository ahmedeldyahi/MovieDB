# 🎬 MovieDB - iOS App  
**Discover Movies** · **Offline Support** · **Clean Architecture**  


[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org/) 
[![iOS](https://img.shields.io/badge/iOS-16%2B-blue)](https://developer.apple.com/ios/)

## 🚀 Features  
- ✅ **Movie Listings**: Now Playing, Popular, Upcoming  
- ✅ **Detailed Movie Info**: Posters, Ratings, Runtime, Budget/Revenue  
- ✅ **Offline Support**: Smart Caching with Core Data  
- ✅ **Error Handling**: Retry UI, Network Error Handling  
- ✅ **Modern Stack**: SwiftUI, MVVM, Async/Await, Combine   

## Setup  
1. **Clone & Open**  
```bash  
git clone https://github.com/ahmedeldyahi/MovieDB.git
open MovieDB.xcodeproj
```
2. **Add API Key**
Create Configuration.swift:
   
```swift  
enum Configuration {  
  static let apiKey = "your_tmdb_key"  
  static let baseURL = URL(string: "https://api.themoviedb.org/3")!  
}
```
3. **Run**
⌘ + R to build & launch

## Architecture
- MovieDB follows a feature-based modular architecture aligned with Domain-Driven Design (DDD) principles. Each feature is structured into three main layers:
- **📂 Features**
	•	Listing (Movie List Screen)
	•	Details (Movie Details Screen)

- **📂 Core**
	•	Shared modules like Networking, Caching

**🔹 Feature-Based Structure**
```bash  
MovieDB  
├── Features  
│   ├── Listing  
│   │   ├── Data  
│   │   │   ├── DataSources  
│   │   │   ├── Repositories  
│   │   │   ├── Cache  
│   │   ├── Domain  
│   │   │   ├── Entities  
│   │   │   ├── Enums  
│   │   │   ├── Repositories  
│   │   │   ├── UseCases  
│   │   ├── Presentation  
│   │       ├── ViewModels  
│   │       ├── Views  
│   ├── Details  
│   │   ├── Domain  
│   │   │   ├── UseCases  
│   │   ├── Presentation  
│   │       ├── ViewModels  
│   │       ├── Views  
├── Core  
│   ├── Networking  
│   ├── Caching  
└── MovieDBApp  
```

## 🔄 Reusability  

1. **Feature Isolation**  
   - `Listing` and `Details` operate independently, promoting scalability.  
   - Each feature contains its own `Domain`, `Data`, and `Presentation` layers.  

2. **Shared Core Modules**  
   - `Networking` and `Caching` in `Core` are reusable across multiple features.  

3. **Encapsulated Data Flow**  
   - Repositories act as intermediaries, making it easy to swap local/remote sources.  

4. **UseCase-Driven Business Logic**  
   - Business rules are inside `UseCases`, making them **testable & reusable** across screens.  
 
## Key Components
```swift  
// Network Layer  
protocol NetworkService {  
  func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T  
}  

// Cached Image  
CachedAsyncImage(url: movie.posterURL) {  
  Image("placeholder").resizable()  
}  

// ViewModel  
@MainActor  
final class MovieListViewModel: ObservableObject {  
  @Published var state: ViewState<[Movie]> = .idle  
}  
```
## Testing
- Unit Tests: Network, Cache, ViewModel States
- Run: ⌘ + U
