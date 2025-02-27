import 'package:smart_task_frontend/block/show_more/show_more_event.dart';
import 'package:smart_task_frontend/block/show_more/show_more_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowMoreBloc extends Bloc<ShowMoreEvent, showMoreStates> {
  ShowMoreBloc() : super(InitStates()) {
    on<isMore>((event, emit) {
      emit(showMoreStates(isShowMore: !state.isShowMore));
    });
  }
}
