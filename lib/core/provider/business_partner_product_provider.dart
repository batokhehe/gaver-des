import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_partner_product/business_partner_product_api.dart';
import '../data/business_partner_product/business_partner_product_repository.dart';
import '../data/model/business_partner_product_model.dart';
import '../network/dio_client.dart';

final businessPartnerProductApiProvider = Provider(
  (ref) => BusinessPartnerProductApi(ref.read(dioProvider)),
);

final businessPartnerProductRepoProvider = Provider(
  (ref) => BusinessPartnerProductRepository(
    ref.read(businessPartnerProductApiProvider),
  ),
);

final businessPartnerProductsProvider =
    FutureProvider.family<List< BusinessPartnerProduct>, int>((ref, id) async {
      return ref.read(businessPartnerProductRepoProvider).getProducts(id);
    });
