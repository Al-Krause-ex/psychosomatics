part of 'illness_cubit.dart';

abstract class IllnessState extends Equatable {
  final List<Illness> illness;
  final List<Illness> filteredIllness;
  final String searchText;
  final List<TypeGroup> typeGroups;

  const IllnessState(
    this.illness,
    this.filteredIllness,
    this.searchText,
    this.typeGroups,
  );
}

class IllnessInitial extends IllnessState {
  const IllnessInitial({
    required List<Illness> illness,
    required List<Illness> filteredIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(illness, filteredIllness, searchText, typeGroups);

  @override
  List<Object> get props => [illness, filteredIllness];
}

class IllnessLoading extends IllnessState {
  const IllnessLoading({
    required List<Illness> illness,
    required List<Illness> filteredIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(illness, filteredIllness, searchText, typeGroups);

  @override
  List<Object> get props => [illness, filteredIllness];
}

class IllnessLoaded extends IllnessState {
  const IllnessLoaded({
    required List<Illness> illness,
    required List<Illness> filteredIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(illness, filteredIllness, searchText, typeGroups);

  @override
  List<Object> get props => [illness, filteredIllness];
}

class IllnessFiltered extends IllnessState {
  const IllnessFiltered({
    required List<Illness> illness,
    required List<Illness> filteredIllness,
    required String searchText,
    required List<TypeGroup> typeGroups,
  }) : super(illness, filteredIllness, searchText, typeGroups);

  @override
  List<Object> get props => [illness, filteredIllness];
}
