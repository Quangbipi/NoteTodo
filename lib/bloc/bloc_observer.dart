import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_todo/bloc/todo_bloc.dart';

class TodoObserver extends BlocObserver{
  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
    if(bloc is TodoBloc){
      print("Transition: $transition");
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    if(bloc is TodoBloc){
      print("Change: $change");
    }

  }
}