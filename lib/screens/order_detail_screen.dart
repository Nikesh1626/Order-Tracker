import 'package:flutter/material.dart';
import '../models/order.dart';
import '../widgets/status_timeline.dart';
import '../utils/formatters.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brandColor = const Color(0xFF5B6EF5);
    final brandLight = const Color(0xFFF0EDFF);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order ${order.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: brandLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person_outline, color: brandColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer details',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: brandColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.customer,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined, size: 14, color: colorScheme.outline),
                            const SizedBox(width: 6),
                            Text(
                              'Placed: ${AppFormatters.dateOnly.format(order.placedAt)} • ${AppFormatters.timeOnly.format(order.placedAt)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // Items Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items (${order.items.length})',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        AppFormatters.currency.format(order.amount),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1),
                  ),
                  ...order.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: brandColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text(
              'Tracking History',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Timeline
            StatusTimeline(
              steps: _buildTimelineSteps(order),
            ),
            
            const SizedBox(height: 32),
            
            // Support Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: brandLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.headset_mic_outlined, color: brandColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need help with your order?',
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contact our support team',
                          style: theme.textTheme.bodyMedium?.copyWith(color: brandColor),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: brandColor),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<TimelineStep> _buildTimelineSteps(Order order) {
    final List<OrderStatus> expectedSequence;
    if (order.status == OrderStatus.cancelled) {
      expectedSequence = [OrderStatus.placed, OrderStatus.cancelled];
    } else {
      expectedSequence = [
        OrderStatus.placed,
        OrderStatus.packed,
        OrderStatus.shipped,
        OrderStatus.outForDelivery,
        OrderStatus.delivered,
      ];
    }

    bool foundCurrent = false;

    return expectedSequence.map((status) {
      final historyItemIndex = order.statusHistory.indexWhere((h) => h.status == status);
      final isCompleted = historyItemIndex != -1;
      final historyItem = isCompleted ? order.statusHistory[historyItemIndex] : null;

      // The first uncompleted status is the "current" one
      bool isCurrent = false;
      if (!isCompleted && !foundCurrent) {
        isCurrent = true;
        foundCurrent = true;
      }

      IconData? icon;
      if (isCompleted) {
        icon = Icons.check; // Completed nodes have a check
      } else if (isCurrent && status == OrderStatus.outForDelivery) {
        icon = Icons.local_shipping_outlined; // Specific icon for current
      } else if (isCurrent && status == OrderStatus.delivered) {
        icon = Icons.home_outlined;
      }

      return TimelineStep(
        title: status.displayName,
        subtitle: historyItem != null 
            ? '${AppFormatters.dateOnly.format(historyItem.timestamp)}, ${AppFormatters.timeOnly.format(historyItem.timestamp)}' 
            : null,
        isCompleted: isCompleted,
        isCurrent: isCurrent,
        completedColor: const Color(0xFF5B6EF5), // Uniform brand blue for ticks
        textColor: Colors.white, // Uniform white checkmark
        icon: icon,
      );
    }).toList();
  }
}
