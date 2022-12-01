import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pupuk_frontend/models/tanaman_model.dart';
import 'package:pupuk_frontend/repository/tanaman_repository.dart';

part 'tanaman_event.dart';
part 'tanaman_state.dart';

class TanamanBloc extends Bloc<TanamanEvent, TanamanState> {
  TanamanBloc() : super(TanamanInitial()) {
    final TanamanRepository tanamanRepository = TanamanRepository();

    on<TanamanEvent>((event, emit) async {
      try {
        emit(TanamanLoading());

        final listPlants = await tanamanRepository.fetchTanamanList();
        emit(TanamanLoaded(listPlants));
      } on NetworkError {
        emit(
          const TanamanError("Failed to fetch data. is your device online?"),
        );
      }
    });

    on<ShowInGridEvent>((event, emit) {
      emit.call(ShowInViewState(true));
    });

    on<ShowInListEvent>((event, emit) {
      emit.call(ShowInViewState(false));
    });
  }
}
