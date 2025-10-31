import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
  var profileImage = Rx<File?>(null);
  Future<void>pickImage()async{
     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
     if(pickedFile!=null){
      profileImage.value = File(pickedFile.path);
     }
  }
}