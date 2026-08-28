import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../customers/domain/entities/customer.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/order_line_item.dart';

part 'order_draft_state.dart';


@singleton
class OrderDraftCubit extends Cubit<OrderDraft> {
  OrderDraftCubit() : super(const OrderDraft());


  void startFor(Customer customer) {
    if (customer == state.customer) return;

    emit(
      state.customer == null
          ? state.copyWith(customer: customer)
          : OrderDraft(customer: customer),
    );
  }

  void toggleProduct(Product product) => state.contains(product.id)
      ? removeProduct(product.id)
      : addProduct(product);

  void addProduct(Product product) {
    if (state.contains(product.id)) return;

    emit(
      state.copyWith(
        lines: [...state.lines, OrderLineItem.fromProduct(product)],
      ),
    );
  }

  void removeProduct(String productId) => emit(
    state.copyWith(
      lines: state.lines.where((line) => line.productId != productId).toList(),
    ),
  );

  void increment(String productId) => _changeQuantity(productId, 1);

  void decrement(String productId) => _changeQuantity(productId, -1);

  void clear() => emit(const OrderDraft());

  void abandonIfEmpty() {
    if (state.customer != null && state.isEmpty) clear();
  }

  void _changeQuantity(String productId, int delta) => emit(
    state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.productId == productId)
            line.copyWith(quantity: max(1, line.quantity + delta))
          else
            line,
      ],
    ),
  );
}
