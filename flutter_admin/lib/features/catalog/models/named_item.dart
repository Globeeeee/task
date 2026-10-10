class NamedItem {
  NamedItem({required this.id, required this.name});

  final String id;
  final String name;

  factory NamedItem.fromJson(Map<String, dynamic> j) => NamedItem(
        id: j['id']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
      );
}
