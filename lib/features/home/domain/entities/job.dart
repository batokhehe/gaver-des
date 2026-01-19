class Job {
  final String id;
  final String title;
  final String address;
  final String? type;
  final int? itemCount;
  final bool isActive;
  final String code;
  final String warehouseName;
  final String warehouseAddress;

  Job({
    required this.id,
    required this.title,
    required this.address,
    required this.code,
    this.type,
    required this.warehouseName,
    required this.warehouseAddress,
    this.itemCount,
    this.isActive = false,
  });

  factory Job.empty() {
    return Job(
      id: '',
      title: '',
      address: '',
      code: '',
      type: null,
      itemCount: null,
      isActive: false,
      warehouseName: '',
      warehouseAddress: '',
    );
  }
}
