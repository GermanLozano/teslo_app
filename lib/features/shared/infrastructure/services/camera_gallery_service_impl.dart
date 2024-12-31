
// implementacion del servicio y las reglas de negocio para la toma y seleccion de imagenes

import 'package:image_picker/image_picker.dart';

import 'camera_gallery_services.dart';

class CameraGalleryServiceImpl extends CameraGalleryServices {

  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,    
    );
  
    if(photo == null ) return null;

    print('Tenemos una imagen ${photo.path}');

    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear    
    );
  
    if(photo == null ) return null;

    print('Tenemos una imagen ${photo.path}');

    return photo.path;
  
  }

}