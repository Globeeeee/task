class Item {
  Item({required this.id, required this.name});

  final String id;
  final String name;

  factory Item.fromJson(Map<String, dynamic> j) => Item(
        id: '${j['id'] ?? ''}',
        name: '${j['name'] ?? ''}',
      );
}
