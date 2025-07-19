
# Handyman App

## Overview

The Handyman App is designed to streamline the logistical management of resources and manpower for contractors. Whether you're involved in roofing, deck building, or remodeling, this app helps contractors manage materials, labor, and project finances all in one place. By reducing the mental burden of tracking project details, this app provides an intuitive, real-time solution to keep contractors organized.

## Features

- **User Authentication**: Secure account creation, sign-in, and sign-out.
- **Project Management**: Add, edit, or delete projects along with associated materials and laborers.
- **Labor and Material Tracking**: Easily manage laborer and material details, including hourly rates, work hours, material costs, and more.
- **Financial Management**: Track the financial health of projects by viewing project pay, material costs, wages, and gross income.
- **Dialogs for Interactivity**: Pop-up forms to add, edit, or delete project-related data, such as laborers, materials, and memos.
- **Real-Time Updates**: With the use of state management, all updates reflect instantly across the app.

## Tech Stack

- **Frontend**: Flutter, Dart
- **Backend**: Node.js, Express.js, MongoDB
- **State Management**: GetX (for frontend state)
- **Authentication**: JSON Web Tokens (JWT)

## Frontend Structure

The frontend is designed to manage contractor projects via a user-friendly interface with multiple pages and dialogs. The app is structured in the following way:

### File Structure

```
frontend/
├── lib/
│   ├── dialogs/
│   │   ├── add_laborer_dialog.dart
│   │   ├── add_material_dialog.dart
│   │   ├── add_memo_dialog.dart
│   │   ├── add_pay_dialog.dart
│   │   ├── create_account_dialog.dart
│   │   ├── delete_laborer_dialog.dart
│   │   ├── delete_material_dialog.dart
│   │   ├── delete_memo_dialog.dart
│   │   ├── edit_laborer_dialog.dart
│   │   ├── edit_material_dialog.dart
│   │   ├── edit_memo_dialog.dart
│   │   ├── sign_in_dialog.dart
│   │   └── sign_out_dialog.dart
│   ├── pages/
│   │   ├── finances_page.dart
│   │   ├── home_page.dart
│   │   ├── labor_page.dart
│   │   ├── materials_page.dart
│   │   └── memo_page.dart
│   ├── utilities/
│   │   ├── base_url.dart
│   │   ├── dependencies.dart
│   │   ├── routes.dart
│   │   └── theme.dart
│   └── main.dart
```

### Key Files and Their Purpose

1. **Dialogs**: These are used for adding, editing, or deleting various elements within a project.
   - **add_laborer_dialog.dart**: Adds a new laborer to a project.
   - **add_material_dialog.dart**: Adds materials associated with the project.
   - **add_memo_dialog.dart**: Adds memos with project details or updates.
   - **sign_in_dialog.dart / sign_out_dialog.dart**: Manages user authentication.

2. **Pages**: These represent the main views of the application.
   - **finances_page.dart**: Displays project financial details (costs, pay, gross income).
   - **labor_page.dart**: Manages laborers, their roles, and work details.
   - **materials_page.dart**: Displays materials for each project.
   - **memo_page.dart**: Displays and manages memos for projects.

3. **Utilities**: Contains essential backend interaction logic and theming for UI consistency.
   - **dependencies.dart**: Centralized state and backend management using GetX.
   - **theme.dart**: Customizes the app's appearance.
   - **base_url.dart**: Manages API endpoints for server communication.

---

## Backend Structure

The backend is built with Node.js and Express.js, using MongoDB for data storage. It handles user authentication, project management, and API routes for handling labor, materials, and finances.

### File Structure

```
back-end/
├── middleware/
│   └── auth.js
├── models/
│   └── user.js
├── routes/
│   └── users.js
├── startup/
│   ├── config.js
│   ├── db.js
│   └── routes.js
├── .env
└── index.js
```

### Key Files and Their Purpose

1. **auth.js**: Handles JWT-based authentication for secure access to protected routes.
2. **user.js**: Contains MongoDB models for user data, projects, materials, and laborers.
3. **users.js**: Defines routes for user management (sign-in, account creation) and project management (adding/editing/removing projects and materials).
4. **config.js**: Manages environment variables such as `JWT_PRIVATE_KEY` to ensure secure operation.
5. **db.js**: Establishes the MongoDB connection for data storage.
6. **routes.js**: Configures API routes and middleware for the backend server.

---

## Environment Variables

Ensure the following environment variables are defined in your `.env` file:

```env
MONGO_URI=mongodb://127.0.0.1:27017/handyman_projectdb
JWT_PRIVATE_KEY=your_private_jwt_key_here
```

---

## How to Run the Application

### Frontend

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the Flutter app:
   ```bash
   flutter run
   ```

### Backend

1. Install dependencies:
   ```bash
   npm install
   ```

2. Run the backend server:
   ```bash
   node index.js
   ```

---

## Contact

- **Author**: Mike Chuvik
- **Email**: [chuvikmike@gmail.com](mailto:chuvikmike@gmail.com)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
