# SkySpy

SkySpy is an iOS application that provides real-time flight tracking and airline information using the AviationStack API. The app allows users to browse airlines, search for airlines by name, save favorite airlines, and view live flight data for selected airlines. Users can view detailed flight information, track flights on a map (when coordinates are available), and filter flights by status (scheduled, active, landed, cancelled, incident, diverted), altitude, arrival delay timeframes, arrival airport, and departure airport.

## API Usage Details

### AviationStack API

SkySpy uses the [AviationStack API](https://aviationstack.com/) to fetch real-time flight data and airline information. The API integration is implemented as follows:

- **API Key**: The application uses an API key stored in `AviationStackEndpoint.swift`. For the app to work, you need to:
  1. Open the `AviationStackEndpoint.swift` file
  2. Locate the `appid` variable
  3. Replace the existing value with your own AviationStack API key
  4. If you don't have an API key, you can get one by signing up at [AviationStack](https://aviationstack.com/)
- **Endpoints Used**:
  - `/v1/airlines` - For fetching airline information
  - `/v1/flights` - For fetching flight data for a specific airline

### API Client Implementation

The API client is structured with the following components:

1. **APIClient**: Handles the network requests and response processing
2. **AviationStackEndpoint**: Defines the endpoints and parameters for API requests
3. **AviationStackService**: Provides methods to fetch airline and flight data

The implementation is designed to be future-proof, with code already in place in the API layer to use the search parameter for airlines should the API provider resolve the "function_access_restricted" issue in the future (check assumptions and limitations below). While the API client is prepared for this change, modifications to the SkySpyViewModel would still be required to use the API's search instead of the current local search implementation.

Example usage:
```swift
// Fetch airline data
let airlineData = try await aviationStackService.fetchAirlineData(for: "Airline Name")

// Fetch flight data
let flightData = try await aviationStackService.fetchFlightData(for: "Airline Name")
```

## App Structure Explanation

SkySpy implements the MVVM (Model-View-ViewModel) architecture pattern to create a maintainable, testable, and scalable application.
This architecture was chosen for its:

- **Clean separation of concerns**: UI logic is separated from business logic
- **Enhanced testability**: ViewModels can be tested independently of UI components
- **Reactive UI**: Data binding enables responsive interface updates
- **Compatibility with SwiftUI**: Aligns with SwiftUI's declarative programming model

### Architecture Overview

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    Views    │◄────┤  ViewModels │◄────┤  Services   │◄────┤    API      │
│             │     │             │     │             │     │             │
└─────────────┘     └──────┬──────┘     └─────┬───────┘     └─────────────┘
                           │                  │
                    ┌──────▼──────┐     ┌─────▼───────┐
                    │ Repositories│     │   Models    │
                    │  (CoreData) │     │             │
                    └─────────────┘     └─────────────┘
```

### Data Flow Process

1. **API Layer**: Fetches data from AviationStack endpoints
2. **Services Layer**: Processes API responses into domain models
3. **Repository Layer**: Manages data persistence with CoreData
4. **ViewModel Layer**: Coordinates business logic and prepares data for display
5. **View Layer**: Renders UI and handles user interactions

<details>
<summary><h3>Details of each component</h3></summary>

#### Models
- **API Models**: `AirlineDataAPI`, `FlightDataAPI` - Raw data structures from API
- **Domain Models**: `SingleAirlineInfo`, `SingleFlightInfo` - App's internal data representation
- **CoreData Models**: Persistent storage schemas for favorites and cached flights data

#### ViewModels
- **SkySpyViewModel**: Coordinates overall app functionality and navigation
- **AirlinesViewModel**: Manages airline listing and favoriting
- **FlightsViewModel**: Handles flight data retrieval and state management
- **FlightsInfoViewModel**: Processes flight data for display and applies filters
- **FiltersViewModel**: Controls filtering options

#### Views
- **SkySpyView**: Main container view and entry point
- **AirlinesView**: Displays searchable airline listings with favorite capabilities
- **FlightsView**: Shows flight information in list or map format based on available data
- **FlightsInfoView**: Displays detailed information for flights
- **MapFlightsView**: Visualizes flights on a map when coordinate data is available
- **FiltersView**: Provides UI for filtering flight results

#### Services & Repositories
- **AviationStackService**: Handles API communication and data transformation
- **FavoriteAirlineRepository**: Manages persistent storage of user favorites
- **FlightDataRepository**: Handles caching and retrieval of flight information

#### Core Protocols
- **Endpointable**: Standardizes API endpoint configuration
- **AviationStackContentLoadable**: Provides consistent loading state management
- **ModelDecodable**: Ensures uniform data parsing across the app
</details>

### User Flow Implementation

1. App launches → SkySpyView checks connectivity → Shows AirlinesView
2. User searches/selects airline → AirlinesViewModel processes selection → Navigation to FlightsView
3. FlightsViewModel fetches flight data → Displays appropriate view based on data availability
4. User applies filters → FiltersViewModel updates criteria → FlightsView refreshes with filtered data

This architecture is designed with the principle that each component has a single responsibility, making the codebase easier to maintain and extend as new features are added. However, it is important to note that while this design aims to apply these concepts, there may be areas where improvements can be made.

## Testing Strategy

SkySpy implements a testing strategy with focus on testability:

### Testability-Focused Design
- The application was designed with testability in mind from the beginning
- Protocols were created specifically to facilitate testing and dependency injection
- Components were structured to allow for easy mocking and isolation during testing

### Mock Objects
- **MockAPIClient**: Mocks the API client for testing network-dependent code
- **MockAviationStackService**: Mocks the AviationStack service
- **MockFavoriteAirlinesRepository**: Mocks the repository for favorite airlines
- **MockFlightDataRepository**: Mocks the flight data repository

### Test Data
- Example JSON responses for testing API parsing:
  - `airlines_response.json`
  - `flights_response.json`
  - Invalid response examples for testing error handling

### Testing Approach
- Unit tests focus on ViewModels and Services to verify business logic correctness
- Tests verify both success paths and error handling scenarios
- Key tested functionalities include:
  - Airline data fetching and transformation
  - Flight filtering logic
  - Favorite airline management

## Assumptions or Limitations

1. **API Rate Limits**: The free tier of AviationStack API has limited requests per month. The app assumes these limits won't be exceeded in normal usage.

2. **Device Compatibility**: The app is designed for iOS and was primarily tested on iPhone 16 Pro. It may not be optimized for all screen sizes or device types.

3. **API Changes**: The app assumes the AviationStack API structure remains stable. Changes to the API may require updates to the app.

4. **API Documentation Discrepancy**: There is a significant mismatch between the AviationStack API documentation and actual behavior. According to the official documentation:

   ```
   search | [Optional] Use this parameter to get autocomplete suggestions for airlines
          |  by specifying any search term as a string. Both free and paid plan subscribers
          |  can use this feature.
   ```

   However, when attempting to use this feature with a request like:
   ```
   https://api.aviationstack.com/v1/airlines?access_key=YOUR_API_KEY&search=ryanair
   ```

   The API returns an error:
   ```json
   {
     "error": {
       "code": "function_access_restricted",
       "message": "Your current subscription plan does not support this API function."
     }
   }
   ```

   As a workaround, the app fetches all airlines using the base endpoint (`https://api.aviationstack.com/v1/airlines?access_key=YOUR_API_KEY`) which returns up to 100 airlines, and then implements local search functionality within the app.

5. **Incomplete API Documentation**: The AviationStack API documentation lacks comprehensive details about the JSON schema. To handle inconsistencies and prevent app crashes, many model properties are implemented as optional in the data models, making the app more resilient to unexpected API responses.


## Suggestions for Future Improvements

1. **Error Handling Improvement**:
   - Expand the current error handling system to distinguish between different error types:
     - Network connectivity errors (no internet connection)
     - API authentication errors (invalid API key)
     - Server errors (500 status codes)
     - Rate limiting errors
     - Data parsing errors
   - Provide user-friendly error messages specific to each error type
   - Add appropriate recovery actions for different error scenarios

2. **Filtering Architecture Improvement**:
   - The current filtering system successfully implements multiple filter types but could benefit from a more unified approach:
     - Currently each filter type has its own implementation pattern
     - The filtering logic is distributed across multiple components
     - Adding new filter types requires changes in multiple locations
   - Implement a more streamlined approach:
     - Consolidate the separate filter arrays into a unified filter structure
     - Create a single filtering mechanism that handles all filter types
     - Implement a more declarative way to define and apply filters
   - This would make future filter extensions more straightforward

3. **MapFlightsView Architecture Improvement**:
   - The MapFlightsView was implemented to demonstrate MapKit integration capabilities, though its architecture deviates from the MVVM pattern used elsewhere
   - Create a proper MapFlightsViewModel that would:
     - Handle map-specific business logic and state management
     - Process flight coordinate data
     - Manage map annotations and region changes
     - Add filters

4. **Navigation Coordinator Implementation**:
   - The current navigation approach relies on SwiftUI's NavigationLink and environment-based dismissal, which:
     - Has the navigation logic directly in views
     - Makes navigation flows difficult to test
   - Implement a Coordinator pattern to:
     - Move navigation code out of the views
     - Make views independent from each other
     - Make it easier to test navigation
   - This pattern would use UINavigationController to manage view transitions while keeping the navigation logic separate from the views themselves
   - The result would be a more maintainable navigation system that could better handle complex flows as the app grows
