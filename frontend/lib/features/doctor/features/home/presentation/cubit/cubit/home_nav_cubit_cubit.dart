import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeTab { home, doctor, chat, profile }

class HomeNavCubit extends Cubit<HomeTab> {
  HomeNavCubit() : super(HomeTab.home);

  void changeTab(HomeTab tab) => emit(tab);
}
