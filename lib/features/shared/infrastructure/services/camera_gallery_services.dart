
// definicion de reglas de negocio para la toma y seleccion de fotos

abstract class CameraGalleryServices {

  Future<String?> takePhoto();
  Future<String?> selectPhoto();



}