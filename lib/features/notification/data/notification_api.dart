import 'package:dio/dio.dart';

import '../../../core/data/model/base_response.dart';
import 'models/notification_model.dart';

class NotificationApi {
  final Dio dio;

  NotificationApi(this.dio);

  Future<BaseResponse<List<NotificationModel>>> fetchNotification({
    int? page = 1,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': 10};

    final response = await dio.get('/user-notifications', queryParameters: query);

    final dataList = response.data['data'] ?? [];
    return BaseResponse(
      data: dataList
          .map<NotificationModel>((e) => NotificationModel.fromJson(e))
          .toList(),
      totalData: response.data['totalData'] ?? 0,
    );
  }
}
