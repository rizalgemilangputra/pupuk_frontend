part of 'tanaman_bloc.dart';

abstract class TanamanEvent extends Equatable {
  const TanamanEvent();

  @override
  List<Object> get props => [];
}

class GetTanamanList extends TanamanEvent {}

class ShowInGridEvent extends TanamanEvent {}

class ShowInListEvent extends TanamanEvent {}
