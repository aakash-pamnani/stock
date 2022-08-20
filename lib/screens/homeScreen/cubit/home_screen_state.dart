part of 'home_screen_cubit.dart';

class HomeScreenState  extends Equatable {
  const HomeScreenState({
    required this.page,
  });
  final int page;
  @override
  List<Object> get props => [page];
}
