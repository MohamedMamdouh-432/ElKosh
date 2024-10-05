import 'package:elkosh/home/widgets/title_text.dart';
import 'package:elkosh/orders/bloc/orders_bloc.dart';
import 'package:elkosh/shared/dummy/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopping = state.curOrder.shopping;
        return Scaffold(
          appBar: AppBar(
            title: Text(state.curOrder.marketName),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    products[0].name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    ' السعرالكلي: ${state.curOrder.total.toStringAsFixed(1)} جنيه',
                  ),
                  Text('رقم الطلب: ${state.curOrder.id}'),
                  Text(
                      'التاريخ: ${DateFormat("yyyy-MM-dd").format(state.curOrder.createdAt)} '),
                  const SizedBox(height: 32.0),
                  ExpansionTile(
                    title: const TitlesTextWidget(label: 'تفاصيل الطلب'),
                    children: List.generate(
                      state.curOrder.shopping.length,
                      (i) => ListTile(
                        leading: const Icon(Icons.shopping_bag_outlined),
                        title: Text(
                            state.curOrder.shopping.keys.elementAt(i).name),
                        isThreeLine: true,
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                '${shopping.keys.elementAt(i).unitVal} ${shopping.keys.elementAt(i).unit}'),
                            Text(
                                '${shopping.keys.elementAt(i).price} ${shopping.values.elementAt(i)}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
