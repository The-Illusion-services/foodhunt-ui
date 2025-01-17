// Cart item widget
import 'package:flutter/material.dart';
import 'package:food_hunt/core/constants/app_constants.dart';
import 'package:food_hunt/core/theme/app_colors.dart';
import 'package:food_hunt/services/models/core/cart.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isSelected;
  final VoidCallback onSelected;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onSelected,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio(
            value: true,
            groupValue: isSelected,
            onChanged: (_) => onSelected(),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bodyTextColor),
                ),
                const SizedBox(height: 4),
                Text(item.details,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                  '$naira${item.price.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontFamily: "JK_Sans",
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.bodyTextColor),
                ),
              ],
            ),
          ),
          // Quantity adjuster
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: onDecrement,
              ),
              Text(item.quantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
