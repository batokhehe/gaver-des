import '../model/business_partner_product_model.dart';
import 'business_partner_product_api.dart';

class BusinessPartnerProductRepository {
  final BusinessPartnerProductApi api;

  BusinessPartnerProductRepository(this.api);

  Future<List<BusinessPartnerProduct>> getProducts(int partnerId) {
    return api.getByPartnerId(partnerId);
  }
}
