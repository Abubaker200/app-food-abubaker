import 'package:flutter/material.dart';
import 'lastlayout.dart'; // تأكد من وجود CheckoutScreen هنا

class MenuItem {
  final String name;
  final String imagePath;
  final double price;
  int quantity;

  MenuItem({
    required this.name,
    required this.imagePath,
    required this.price,
    this.quantity = 0,
  });
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItem> items = [
    MenuItem(name: 'بيتزا', imagePath: 'lib/image/11475300.png', price: 19.0),
    MenuItem(name: 'برغر', imagePath: 'lib/image/burger.jpg', price: 9.0),
    MenuItem(name: 'شاورما دجاج', imagePath: 'lib/image/small-showrma.jpg', price: 9.0),
    MenuItem(name: 'وجبة شاورما دجاج', imagePath: 'lib/image/showrma-all.jpg', price: 35.0),
    MenuItem(name: 'وجبة نص دجاج', imagePath: 'lib/image/shalfffff.jpg', price: 21.0),
    MenuItem(name: 'مشروب غازي', imagePath: 'lib/image/ff8868ea-ae64-4f14-bd20-d619827fcbed.jpg', price: 4.0),
    MenuItem(name: 'ماء', imagePath: 'lib/image/3127570.jpg', price: 2.0),
  ];

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  void increaseQty(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  void decreaseQty(int index) {
    setState(() {
      if (items[index].quantity > 0) {
        items[index].quantity--;
      }
    });
  }

  void navigateToCheckout() {
    final selectedItems = items
        .where((item) => item.quantity > 0)
        .map((item) => {
              'name': item.name,
              'image': item.imagePath,
              'price': item.price,
              'quantity': item.quantity,
            })
        .toList();

    if (selectedItems.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            selectedItems: selectedItems,
            total: totalPrice,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار عنصر واحد على الأقل')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // خلفية دافئة ناعمة
      appBar: AppBar(
        title: const Text('قائمة الطعام'),
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item.imagePath,
                            width: 70,
                            height: 70,
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'السعر: ${item.price} د.ل',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.deepOrange),
                              onPressed: () => decreaseQty(index),
                            ),
                            Text('${item.quantity}',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: Colors.deepOrange),
                              onPressed: () => increaseQty(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // فاصل
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(thickness: 1),
          ),

          // إجمالي الفاتورة
          GestureDetector(
            onTap: navigateToCheckout,
            child: Card(
              margin: const EdgeInsets.all(12),
              color: Colors.deepOrange[200],
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'إجمالي الفاتورة:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${totalPrice.toStringAsFixed(2)} د.ل',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
