import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedFilterCubit extends Cubit<int> {
  SelectedFilterCubit() : super(0);

  void changeFilter(int num) {
    emit(num);
  }
}
