import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CartModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;
  @HiveField(3)
  String discription;
  @HiveField(4)
  double price;
  @HiveField(5)
  int quantity;
  @HiveField(6)
  String category;

  CartModel({
    this.id,
    this.name,
    this.image,
    this.discription,
    this.price,
    this.quantity,
  });
}

class CartAdapter extends TypeAdapter<CartModel> {
  @override
  final typeId = 0;

  @override
  CartModel read(BinaryReader reader) {
    return CartModel()
      ..name = reader.read()
      ..id = reader.read()
      ..image = reader.read()
      ..discription = reader.read()
      ..price = reader.read()
      ..quantity = reader.read();
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer.write(obj.name);
    writer.write(obj.id);
    writer.write(obj.image);
    writer.write(obj.discription);
    writer.write(obj.price);
    writer.write(obj.quantity);
  }
}
