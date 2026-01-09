import 'package:dio/dio.dart';
import 'package:gaver_des/core/data/model/base_response.dart';
import 'package:intl/intl.dart';

import 'models/task_model.dart';

class TaskApi {
  final Dio dio;

  TaskApi(this.dio);

  Future<BaseResponse<List<TaskModel>>> fetchPickUp({
    required String status,
    String? search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': 10,
      'status': status,
      'sortCol': sortCol ?? 'pickupDate',
      'sortOrder': 'asc',
      'driverId': driverId,
    };

    // 🔍 search opsional
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    // 📅 date range opsional
    if (startDate != null && endDate != null) {
      query['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
      query['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);
    }

    final response = await dio.get('/pickup-orders', queryParameters: query);

    final dataList = response.data['data'] ?? [];

    return BaseResponse(
      data: dataList.map<TaskModel>((e) => TaskModel.fromJson(e)).toList(),
      totalData: response.data['totalData'] ?? 0,
    );
  }

  Future<BaseResponse<List<TaskModel>>> fetchDelivery({
    required String status,
    required String search,
    String? sortCol,
    DateTime? startDate,
    DateTime? endDate,
    required int driverId,
    int page = 1,
  }) async {
    final response = await dio.get(
      '/pickup-orders',
      queryParameters: {
        'page': page,
        'limit': 10,
        'search': search,
        'status': status,
        'sortCol': sortCol ?? 'pickupDate',
        'sortOrder': 'asc',
        'driverId': driverId,
      },
    );

    final dataList = response.data['data'] ?? [];
    return BaseResponse(
      data: dataList.map<TaskModel>((e) => TaskModel.fromJson(e)).toList(),
      totalData: response.data['totalData'] ?? 0,
    );
  }
}
