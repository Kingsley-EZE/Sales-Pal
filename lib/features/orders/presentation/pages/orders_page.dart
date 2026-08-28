import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_pal/design/components/app_segmented_tabs.dart';
import 'package:sales_pal/design/components/app_status_view.dart';
import 'package:sales_pal/design/spacing.dart';
import 'package:sales_pal/features/orders/presentation/cubit/order_queue_cubit.dart';
import 'package:sales_pal/features/orders/presentation/widgets/order_queue_card.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderQueueCubit, OrderQueueState>(
      listenWhen: (_, state) =>
          state is OrderQueueLoaded && state.retryFailureMessage != null,
      listener: (context, state) {
        final queue = context.read<OrderQueueCubit>();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text((state as OrderQueueLoaded).retryFailureMessage!),
          ),
        );
        queue.clearRetryFailure();
      },
      builder: (context, state) => switch (state) {
        OrderQueueLoading() => const AppLoadingView(),
        OrderQueueFailed(:final message) => AppStatusView(
          message: message,
          onRetry: context.read<OrderQueueCubit>().load,
        ),
        OrderQueueLoaded() => _Queue(state: state),
      },
    );
  }
}

class _Queue extends StatelessWidget {
  const _Queue({required this.state});

  final OrderQueueLoaded state;

  @override
  Widget build(BuildContext context) {
    final queue = context.read<OrderQueueCubit>();
    final orders = state.visible;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: AppSegmentedTabs(
            labels: [
              'Pending (${state.pending.length})',
              'Submitted (${state.submitted.length})',
            ],
            selectedIndex: state.tab.index,
            onChanged: (index) => queue.selectTab(OrderQueueTab.values[index]),
          ),
        ),
        Expanded(
          child: orders.isEmpty
              ? AppStatusView(message: _emptyMessage)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return OrderQueueCard(
                      order: order,
                      isExpanded: state.isExpanded(order),
                      isRetrying: state.isRetrying(order),
                      onToggle: () => queue.toggleExpanded(order),
                      onRetry: () => queue.retry(order),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                ),
        ),
      ],
    );
  }

  String get _emptyMessage => switch (state.tab) {
    OrderQueueTab.pending => 'Nothing waiting to be sent.',
    OrderQueueTab.submitted => 'No orders have been submitted yet.',
  };
}
