import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(const HomeScreenState(page: 0));

  void changePage(int page) {
    // if(state.page != page) {
    emit(HomeScreenState(page: page));
    // }
  }

  
}
