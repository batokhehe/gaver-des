class BaseResponse<T> {
  final T data;
  final int totalData;

  BaseResponse({required this.data, required this.totalData});
}
