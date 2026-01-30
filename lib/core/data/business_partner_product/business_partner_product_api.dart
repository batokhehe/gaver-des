import 'package:dio/dio.dart';

import '../model/business_partner_product_model.dart';

class BusinessPartnerProductApi {
  final Dio dio;

  BusinessPartnerProductApi(this.dio);

  Future<List<BusinessPartnerProduct>> getByPartnerId(int id) async {
    final res = await dio.get(
      '/business-partner-products/business-partner/$id',
    );

    final list = res.data['data'] as List;
    return list.map((e) => BusinessPartnerProduct.fromJson(e)).toList();
  }
}
