import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kanhas/models/order_history_model.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderHistoryModel>(
      builder: (context, orderHistory, child) {
        if (orderHistory.orders.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Riwayat Pesanan'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Riwayat Pesanan Kosong',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Semua pesanan Anda yang selesai akan muncul di sini.',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Riwayat Pesanan'),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orderHistory.orders.length,
            itemBuilder: (context, index) {
              final order = orderHistory.orders[index];

              final String formattedDate =
                  "${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year} "
                  "${order.orderDate.hour.toString().padLeft(2, '0')}:"
                  "${order.orderDate.minute.toString().padLeft(2, '0')}";

              final String itemSummary = order.items
                  .map((item) => "${item.menu.name} (x${item.quantity})")
                  .join(', ');

              return Card(
                elevation: 3,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Rp ${order.totalPrice}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Text(
                        itemSummary,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Order ID: #${order.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
