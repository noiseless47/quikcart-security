import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/security_provider.dart';

class ItemListWidget extends StatelessWidget {
  const ItemListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SecurityProvider>(
      builder: (context, provider, child) {
        final bill = provider.currentBill;
        if (bill == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No bill scanned',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: bill.items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = bill.items[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: Text(
                item.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'Quantity: ${item.price}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  item.isVerified ? Icons.check_circle : Icons.pending_outlined,
                  color: item.isVerified
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  size: 28,
                ),
              ),
            );
          },
        );
      },
    );
  }
}