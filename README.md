
# URLSessionNetworkCaller

## Overview
`URLSessionNetworkCaller` is a Swift package designed to simplify making network requests with Combine. It provides a reusable, type-safe API client that supports various HTTP methods and integrates seamlessly with Combine to handle asynchronous data streams.

## Features

- **Generic Network Caller**: Make network requests for any `Codable` type.
- **Singleton API Client**: Reusable `ApiClient` shared instance.
- **Supported HTTP Methods**: Includes support for `GET`, `POST`, `PUT`, `DELETE`, and `PATCH`.
- **Parameter Handling**:
  - Query parameters for `GET` requests.
  - JSON body parameters for `POST`, `PUT`, `DELETE`, and `PATCH` requests.

## Installation

### Swift Package Manager

You can add `URLSessionNetworkCaller` to your project using Swift Package Manager.

1. **In Xcode**, go to `File` > `Add Packages...`
2. **Enter the repository URL**: `https://github.com/Thommzy/URLSessionNetworkCaller`
3. **Select the package options** and click `Add Package`

### Manual

1. Clone the repository:
    ```sh
    git clone https://github.com/Thommzy/URLSessionNetworkCaller.git
    ```

2. Drag the `URLSessionNetworkCaller` folder into your Xcode project.

## Usage

### Setting Up the API Client

The `URLSessionNetworkCaller` class is used to make network requests. Here’s an example of how to use it in a ViewModel.

#### Creating a Network Caller

```swift
import Foundation
import Combine
import URLSessionNetworkCaller

final class HomeViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    @Published var characters: [Character]?
    @Published var isLoading = false
    @Published var networkError: Error?
    private var networkCaller: URLSessionNetworkCaller<Characters>
    
    init(networkCaller: URLSessionNetworkCaller<Characters> = URLSessionNetworkCaller<Characters>(
        baseURL: "https://rickandmortyapi.com/api/",
        urlPath: "character",
        method: .get,
        type: Characters.self,
        parameter: nil
    )) {
        self.networkCaller = networkCaller
        fetchCharacters()
    }
    
    func fetchCharacters() {
        isLoading = true
        
        networkCaller.makeNetworkRequest()
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.isLoading = false
                    print("Request finished")
                case .failure(let error):
                    self.isLoading = false
                    self.networkError = error
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                self.characters = response.results
                print("Received response: \(response)")
            })
            .store(in: &cancellables)
    }
}
```

### Making a Network Request

#### Example: Fetch Characters from the Rick and Morty API

1. **Define Your Models**:
    ```swift
    import Foundation

    struct Characters: Codable {
        let results: [Character]
    }

    struct Character: Codable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let image: String
        // Add other fields as needed
    }
    ```

2. **Use in ViewModel**:
    ```swift
    final class HomeViewModel: ObservableObject {
        // ViewModel code as shown above
    }
    ```

3. **Fetch Data in the View**:
    ```swift
    😊 
    ```

## API Reference

### `URLSessionNetworkCaller`

A generic class to make network requests for any `Codable` type.

#### Initializer

```swift
public init(
    baseURL: String,
    urlPath: String,
    method: Method,
    type: T.Type,
    parameter: [String: Any]?
)
```

- **baseURL**: The base URL of the API.
- **urlPath**: The specific path of the resource.
- **method**: The HTTP method (GET, POST, PUT, DELETE, PATCH).
- **type**: The type of the expected response, conforming to `Codable`.
- **parameters**: Optional parameters for the request.

#### Methods

- `open func makeNetworkRequest() -> AnyPublisher<T, Error>`
  - Makes the network request and returns a publisher.

### `Method`

An enum representing the supported HTTP methods.

- `case get`
- `case post`
- `case put`
- `case delete`
- `case patch`

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any improvements or bug fixes.

### Steps to Contribute

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add some feature'`).
5. Push to the branch (`git push origin feature-branch`).
6. Open a pull request.

## Contact

For any questions or inquiries, please contact [Timothy Obeisun](mailto:timothyobeisun@gmail.com).
