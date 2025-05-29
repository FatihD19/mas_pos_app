import 'package:flutter/material.dart';
import 'package:mas_pos_app/feature/product/presentation/widgets/cart_button.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          // Status bar

          // App bar
          Row(
            children: [
              Text(
                'MASPOS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              Spacer(),
              // Icon(Icons.search_outlined, size: 24, color: Colors.grey[600]),
              SizedBox(width: 16),
              CartButton(),
              SizedBox(width: 16),
              CircleAvatar(
                radius: 16,
                child: Icon(Icons.person_outline,
                    size: 24, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
