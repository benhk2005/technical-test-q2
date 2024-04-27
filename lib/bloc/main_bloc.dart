import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovup_flutter/helper/api_helper.dart';
import 'package:moovup_flutter/model/person.dart';

class MainBlocLoadEvent {}

class MainBlocState {
  bool isLoading = true;
  List<Person> people = List.empty();
  MainBlocState({required this.isLoading, required this.people});
}

class MainBloc extends Bloc<MainBlocLoadEvent, MainBlocState> {
  MainBloc(super.initialState) {
    on<MainBlocLoadEvent>(loadPeopleInfoFromAPI);
    add(MainBlocLoadEvent());
  }

  void loadPeopleInfoFromAPI(MainBlocLoadEvent event, Emitter emitter) async {
    final people = await APIHelper.getPeople();
    emitter(
      MainBlocState(
        isLoading: false,
        people: people,
      ),
    );
  }
}
