import 'package:cloud_functions/cloud_functions.dart';

class Cloudfunctionscodes {
  Future<dynamic> ImageAndTimeStamp(String Url) async{
    final functions = FirebaseFunctions.instance;
    try{
      final result = await functions.httpsCallable('ImageAndTimeStamp').call(
        {
          "text" : Url
        },
      );
      print(result.data);
      var json = await result.data;
      return await json;
    } on FirebaseFunctionsException catch (err) {
      print(err);
      return err;
    }
  }
}