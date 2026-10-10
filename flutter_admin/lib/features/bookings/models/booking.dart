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

  bool get pending => status == 'pending';

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
        id: j['id']?.toString() ?? '',
        customerName: j['customerName']?.toString() ?? '',
        serviceName: j['serviceName']?.toString() ?? '',
        stylistName: j['stylistName']?.toString() ?? '',
        slotStart: j['slotStart']?.toString() ?? '',
        status: j['status']?.toString() ?? '',
      );
}
