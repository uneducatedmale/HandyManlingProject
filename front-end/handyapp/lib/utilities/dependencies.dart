import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

/*
  File: dependencies.dart
  Purpose:
  - Serves as the central controller for managing user authentication, project data, and backend API interactions.
  - Handles state management for the app using `GetX`.

  Features:
  - User Authentication:
    - Account creation, sign-in, and sign-out functionality.
  - Project Management:
    - Adding, editing, and deleting projects and their associated memos.
  - Material Management:
    - Adding, editing, and deleting materials associated with specific projects.
  - Laborer Management:
    - Adding, editing, and deleting laborers linked to projects.
  - Payment Updates:
    - Updating the payment details for projects.

  How It Works:
  - `AuthController`: Provides reactive state management for user authentication and project data.
  - API Integration:
    - Connects to backend endpoints defined in `base_url.dart` for seamless CRUD operations.
  - State Management:
    - Utilizes `Rx` variables in `GetX` for live updates to the UI when data changes.

  Files It Interacts With:
  - **`base_url.dart`**: Provides the base API URL for all endpoints.
  - Backend Endpoints:
    - `/api/users/create-account`: For creating new accounts.
    - `/api/users/sign-in`: For user authentication.
    - `/api/users/add-project`, `/api/users/edit-memo`, `/api/users/delete-project`: For project management.
    - `/api/users/add-material`, `/api/users/edit-material`, `/api/users/delete-material`: For material management.
    - `/api/users/add-laborer`, `/api/users/edit-laborer`, `/api/users/delete-laborer`: For laborer management.
    - `/api/users/update-pay`: For updating project payment details.

  Notes:
  - This file is critical for all backend interactions and state updates in the app.
  - Ensure backend APIs are functional and return appropriate responses to maintain app stability.
*/
class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('$baseUrl/api/users/create-account');
  final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');
  final addProjectUrl = Uri.parse('$baseUrl/api/users/add-project');
  final deleteProjectUrl = Uri.parse('$baseUrl/api/users/delete-project');
  final addMaterialUrl = Uri.parse('$baseUrl/api/users/add-material');
  final deleteMaterialUrl = Uri.parse('$baseUrl/api/users/delete-material'); // Endpoint for deleting material
  final editMaterialUrl = Uri.parse('$baseUrl/api/users/edit-material'); // Endpoint for editing material
  final addLaborerUrl = Uri.parse('$baseUrl/api/users/add-laborer');
  final deleteLaborerUrl = Uri.parse('$baseUrl/api/users/delete-laborer'); // Endpoint for deleting laborer
  final editLaborerUrl = Uri.parse('$baseUrl/api/users/edit-laborer'); // Endpoint for editing laborer
  final updateProjectPayUrl = Uri.parse('$baseUrl/api/users/update-pay'); // Endpoint for updating pay

  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;
  RxList projects = [].obs;

  Future<String> createAccount(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    try {
      var createAccountData = await http.post(
        createAccountUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        }),
      );
      if (createAccountData.statusCode == 200) {
        return 'success';
      } else {
        return createAccountData.body.toString();
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> signIn(
    String email,
    String password,
  ) async {
    try {
      var signInData = await http.post(
        signInUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );
      if (signInData.statusCode == 200) {
        final jsonSignInData = jsonDecode(signInData.body);
        isSignedIn.value = true;
        token.value = jsonSignInData['token'];
        signedInEmail.value = jsonSignInData['email'];
        projects.clear();
        projects.addAll(jsonSignInData['projects']);
        return 'success';
      } else {
        return signInData.body.toString();
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> addProject(String name, String memo) async {
    try {
      var addProjectData = await http.post(
        addProjectUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'name': name,
          'memo': memo,
        }),
      );
      if (addProjectData.statusCode == 200) {
        final jsonAddProjectData = jsonDecode(addProjectData.body);
        projects.clear();
        projects.addAll(jsonAddProjectData);
        return 'success';
      } else {
        return addProjectData.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> deleteProject(int index) async {
    try {
      var deleteProjectData = await http.post(
        deleteProjectUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'index': index,
        }),
      );
      if (deleteProjectData.statusCode == 200) {
        final jsonDeleteProjectData = jsonDecode(deleteProjectData.body);
        projects.clear();
        if (jsonDeleteProjectData.isNotEmpty) {
          projects.addAll(jsonDeleteProjectData);
        }
        return 'success';
      } else {
        return deleteProjectData.body.toString();
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> editProjectMemo(int index, String name, String memo) async {
  try {
    var response = await http.post(
      Uri.parse('$baseUrl/api/users/edit-memo'), // Backend endpoint for editing
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({
        'index': index,
        'name': name,
        'memo': memo,
      }),
    );

    if (response.statusCode == 200) {
      final updatedProjects = jsonDecode(response.body);
      projects.clear();
      projects.addAll(updatedProjects);
      return 'success';
    } else {
      return response.body;
    }
  } catch (error) {
    return error.toString();
  }
}


  Future<String> addMaterial(String projectId, String name, int quantity, double value) async {
    try {
      var response = await http.post(
        addMaterialUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'name': name,
          'quantity': quantity,
          'value': value,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> deleteMaterial(String projectId, String materialId) async {
    try {
      var response = await http.post(
        deleteMaterialUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'materialId': materialId,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> editMaterial(
    String projectId,
    String materialId,
    String name,
    int quantity,
    double value,
  ) async {
    try {
      var response = await http.post(
        editMaterialUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'materialId': materialId,
          'name': name,
          'quantity': quantity,
          'value': value,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> addLaborer(
    String projectId,
    String name,
    String job,
    double hourlyWage,
    int hoursWorked,
  ) async {
    try {
      var response = await http.post(
        addLaborerUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'name': name,
          'job': job,
          'hourlyWage': hourlyWage,
          'hoursWorked': hoursWorked,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> deleteLaborer(String projectId, String laborerId) async {
    try {
      var response = await http.post(
        deleteLaborerUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'laborerId': laborerId,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> editLaborer(
    String projectId,
    String laborerId,
    String name,
    String job,
    double hourlyWage,
    int hoursWorked,
  ) async {
    try {
      var response = await http.post(
        editLaborerUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'laborerId': laborerId,
          'name': name,
          'job': job,
          'hourlyWage': hourlyWage,
          'hoursWorked': hoursWorked,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> updateProjectPay(String projectId, double jobPay) async {
    try {
      var response = await http.post(
        updateProjectPayUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode({
          'projectId': projectId,
          'jobPay': jobPay,
        }),
      );

      if (response.statusCode == 200) {
        final updatedProjects = jsonDecode(response.body);
        projects.clear();
        projects.addAll(updatedProjects);
        return 'success';
      } else {
        return response.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  void signOut() {
    Get.offNamed('/home_page');
    projects.clear();
    token.value = '';
    isSignedIn.value = false;
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(
      AuthController(),
    );
  }
}
