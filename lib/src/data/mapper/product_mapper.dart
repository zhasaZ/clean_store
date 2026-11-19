import '../../../models/product_model.dart';
import '../../domain/entities/product.dart';

extension ProductModelMapper on ProductModel {
  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        imageUrl: image,
        rating: rating,
      );
}

extension ProductEntityMapper on Product {
  ProductModel toModel() => ProductModel(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        image: imageUrl,
        rating: rating,
      );
}
