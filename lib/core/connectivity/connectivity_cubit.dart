import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';


@singleton
class ConnectivityCubit extends Cubit<bool> {
  ConnectivityCubit() : super(true);

  bool get isOnline => state;

  void toggle() => emit(!state);

  void setOnline({required bool isOnline}) => emit(isOnline);
}
