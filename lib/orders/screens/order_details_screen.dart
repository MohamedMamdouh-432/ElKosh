import 'package:elkosh/shared/dummy/products.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/title_text.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(products[0].name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                products[0].imgUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 16.0),
              Text(
                products[0].name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16.0),
              Text(
                ' السعرالكلي: \$${products[0].price.toStringAsFixed(1)}',
              ),
              Text('رقم الطلب: ${products[0].id}'),
              Text('التاريخ: ${DateTime.now().toString().substring(0, 10)} '),
              const SizedBox(height: 32.0),
              ExpansionTile(
                title: const TitlesTextWidget(label: 'تفاصيل الطلب'),
                children: products.map((order) {
                  return ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text('رقم الطلب: ${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'التاريخ: ${DateTime.now().toString().substring(0, 10)} '),
                        const Text('الكميه: '),
                        const Text('السعر: \$5'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
