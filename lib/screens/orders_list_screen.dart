import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/order_provider.dart';
import '../widgets/order_list_tile.dart';
import 'order_detail_screen.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        actions: [
          Row(
            children: [
              const Text('Force Error', style: TextStyle(fontSize: 12)),
              Switch(
                value: ref.watch(forceErrorProvider),
                onChanged: (val) {
                  ref.read(forceErrorProvider.notifier).set(val);
                  if (val) {
                    ref.read(orderProvider.notifier).fetchOrders();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (orderState.isOffline) const _OfflineBanner(),
          Expanded(
            child: _buildBody(context, ref, orderState),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, OrderState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return const _LoadingView();
    }

    if (state.error != null && state.orders.isEmpty) {
      return _ErrorView(
        errorMsg: state.error!,
        onRetry: () => ref.read(orderProvider.notifier).fetchOrders(),
      );
    }

    if (state.orders.isEmpty) {
      return _EmptyOrdersView(
        onRefresh: () => ref.read(orderProvider.notifier).fetchOrders(),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(orderProvider.notifier).fetchOrders(),
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: state.orders.length,
          itemBuilder: (context, index) {
            final order = state.orders[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: OrderListTile(
                    order: order,
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              OrderDetailScreen(order: order),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colorScheme.errorContainer,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'You\'re offline — showing last loaded orders',
        textAlign: TextAlign.center,
        style: TextStyle(color: colorScheme.onErrorContainer),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  final String errorMsg;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.errorMsg,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong.',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            errorMsg,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrdersView extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyOrdersView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'No orders found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}
