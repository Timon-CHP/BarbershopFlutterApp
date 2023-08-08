import 'package:dio/dio.dart';
import 'package:flutter_maihomie_app/core/services/booking_service.dart';
import 'package:flutter_maihomie_app/core/services/product_service.dart';
import 'package:flutter_maihomie_app/core/state_models/base.dart';
import 'package:flutter_maihomie_app/service_locator.dart';
import 'package:image_picker/image_picker.dart';

class ProductModel extends BaseModel {
  final _productService = locator<ProductService>();
  final _bookingService = locator<BookingService>();

  Future<bool> createProduct(
      {required Map<String, dynamic> data, required PickedFile image}) async {
    data.addAll({
      "image": await MultipartFile.fromFile(
        image.path,
      )
    });

    FormData formData = FormData.fromMap(data);

    var res = await _productService.createProduct(data: formData);

    if (res != null) {
      return true;
    }

    return false;
  }

  Future<bool> editProduct({
    required Map<String, dynamic> data,
    PickedFile? image,
    required int productId,
  }) async {
    if (image != null) {
      data.addAll({
        "image": await MultipartFile.fromFile(
          image.path,
        )
      });
    }

    FormData formData = FormData.fromMap(data);

    var res = await _productService.editProduct(
      data: formData,
      productId: productId,
    );
    if (res != null) {
      return true;
    }

    return false;
  }

  Future<bool> deleteProduct({required int productId}) async {
    return await _productService.deleteProduct(productId: productId) ?? false;
  }

  Future getAllProduct() async {
    await _bookingService.getAllProduct();
    notifyListeners();
  }
}
