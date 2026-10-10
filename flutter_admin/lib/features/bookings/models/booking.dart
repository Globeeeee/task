class Booking {
  Booking({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.stylistName,
    required this.slotStart,
    required this.status,
  });

  final String id;
  final String customerName;
  final String serviceName;
  final String stylistName;
  final String slotStart;
  final String status;

  bool get isPending => status == 'pending';

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      customerName: json['customerName']?.toString() ?? '',
      serviceName: json['serviceName']?.toString() ?? '',
      stylistName: json['stylistName']?.toString() ?? '',
      slotStart: json['slotStart']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
