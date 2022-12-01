part of 'tanaman_bloc.dart';

abstract class TanamanState extends Equatable {
  const TanamanState();

  @override
  List<Object> get props => [];
}

class TanamanInitial extends TanamanState {}

class TanamanLoading extends TanamanState {}

class TanamanLoaded extends TanamanState {
  final List<TanamanModel> tanamanModel;
  const TanamanLoaded(this.tanamanModel);
}

class TanamanError extends TanamanState {
  final String? message;
  const TanamanError(this.message);
}

// ignore: must_be_immutable
class ShowInViewState extends TanamanState {
  bool inGrid = true;
  ShowInViewState(this.inGrid);
}
