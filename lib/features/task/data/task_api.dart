import 'package:dio/dio.dart';
import 'package:gaver_des/core/data/model/base_response.dart';

import 'models/task_model.dart';

class TaskApi {
  final Dio dio;

  TaskApi(this.dio);

  Future<BaseResponse<List<TaskModel>>> fetchPickUp({
    required String status,
    String search = '',
    required int driverId,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/pickup-orders',
      queryParameters: {
        'page': page,
        // 'driverId': driverId,
        'limit': 10,
        'status': status,
        'search': search,
      },
    );

    final dataList = response.data['data'] ?? [];

    return BaseResponse(
      data: dataList.map<TaskModel>((e) => TaskModel.fromJson(e)).toList(),
      totalData: response.data['totalData'] ?? 0,
    );
  }

  Future<BaseResponse<List<TaskModel>>> fetchDelivery({
    required String status,
    required String search,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/pickup-orders',
      queryParameters: {
        'page': page,
        'limit': 10,
        'search': search,
        'status': status,
        'sortCol': 'pickupDate',
        'sortOrder': 'asc',
      },
    );

    final dataList = response.data['data'] ?? [];
    return BaseResponse(
      data: dataList.map<TaskModel>((e) => TaskModel.fromJson(e)).toList(),
      totalData: response.data['totalData'] ?? 0,
    );
  }
}
