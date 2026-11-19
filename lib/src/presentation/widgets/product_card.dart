import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported_outlined),
          ),
        ),
        title: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}  ·  ★ ${product.rating}'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
          onPressed: onFavoriteTap,
        ),
      ),
    );
  }
}
