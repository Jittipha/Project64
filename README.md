# กิจกรรมนักศึกษา
โปรเจคเว็บแอพ กิจกรรมนักศึกษา จัดทำโดย นาย คนึงศักษ์ เพชรสวัสดิ์
## Features

* โพสกิจกรรมได้
* หาเพื่อนเข้าร่วมกิจกรรมได้
* มีเว็บแอตมินคอยจัดการ

##  Example code
class LoginController extends GetxController {

    var _googleSingin = GoogleSignIn();
    var googleAccount = Rx<GoogleSignInAccount?>(null);

    login() async {
      googleAccount.value = await _googleSingin.signIn();
    }

    logout() async {
      googleAccount.value = await _googleSingin.signOut();
    }
 
}

##  Credit
610107030003@dpu.ac.th

##  License

<!-- # project -->
<!-- A new Flutter project. -->

<!-- ## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->
#   C R U D  
 