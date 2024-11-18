/*
  File: base_url.dart
  Purpose:
  - Provides the base URL for API requests, ensuring centralized management of server endpoints.
  
  Functionality:
  - Allows switching between a local development server (`localhost`) and a deployed production server.
  - Simplifies updates to the base URL for all API calls in the application.

  How It Works:
  - The `baseUrl` string defines the server URL to which the app sends HTTP requests.
  - The commented-out line enables easy toggling between environments.

  Files It Interacts With:
  - Used by `dependencies.dart` and other utility files for constructing API request URLs.
  - Ensures consistency and easy maintenance of server configuration across the app.
*/

String baseUrl = 'http://localhost:3000';
//String baseUrl = 'https://memo-web-app-back-end.onrender.com';

