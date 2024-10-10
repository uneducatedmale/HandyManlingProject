import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';

class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('$baseUrl/api/users/create-account');
  final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');
  final addMemoUrl = Uri.parse('$baseUrl/api/users/add-memo');
  final deleteMemoUrl = Uri.parse('$baseUrl/api/users/delete-memo');

  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;
  RxList memos = [].obs;

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
        memos.clear();
        memos.addAll(jsonSignInData['memos']);
        return 'success';
      } else {
        return signInData.body.toString();
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> addMemo(String content) async {
    try {
      var addMemoData = await http.post(
        addMemoUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode(
          {
            'content': content,
          },
        ),
      );
      if (addMemoData.statusCode == 200) {
        final jsonAddMemoData = jsonDecode(addMemoData.body);
        memos.clear();
        memos.addAll(jsonAddMemoData);
        return 'success';
      } else {
        return addMemoData.body;
      }
    } catch (error) {
      return '$error';
    }
  }

  Future<String> deleteMemo(int index) async {
    try {
      var deleteMemoData = await http.post(
        deleteMemoUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
        body: jsonEncode(
          {
            'index': index,
          },
        ),
      );
      if (deleteMemoData.statusCode == 200) {
        final jsonDeleteMemoData = jsonDecode(deleteMemoData.body);
        memos.clear();
        if (jsonDeleteMemoData.isNotEmpty) {
          memos.addAll(jsonDeleteMemoData);
        }
        return 'success';
      } else {
        return deleteMemoData.body.toString();
      }
    } catch (error) {
      return error.toString();
    }
  }

  void signOut() {
    Get.offNamed('/home_page');
    memos.clear();
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
