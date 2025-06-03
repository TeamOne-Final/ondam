import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondam_app/vm/chart_controller.dart';

class ImageController extends ChartController{
  //
  final imageFile = Rx<XFile?>(null); // null을 허용하면 .obs를 못 써서 대신에 Rx를 붙임
  final ImagePicker picker = ImagePicker();

  Future<void> getImageFromGallery(ImageSource source)async{
    final XFile? pickedFile = await picker.pickImage(source: source);
    if(pickedFile != null){
      imageFile.value = pickedFile;
    }
  }
}