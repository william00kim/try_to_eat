import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {

  void toastMessageMethod(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        fontSize: 14
    );
  }

}