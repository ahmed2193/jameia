class BaseResponse<Type> {
  int? statusCode;
  String? message;
  Type? data;
  Type? extraData;
  int? currentPage;
  int? lastPage;

  BaseResponse({
    this.statusCode,
    this.message,
    this.data,
    this.extraData,
    this.currentPage,
    this.lastPage,
  });
}
