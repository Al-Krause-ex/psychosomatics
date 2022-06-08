part of 'filter_organs_cubit.dart';

enum FilterActions { choose, check, cancel, initial }

class FilterOrgansState extends Equatable {
  final Map<Organ, bool> checkboxes;
  // final FilterActions action;
  // final Map<Organ, bool> organ;

  const FilterOrgansState(this.checkboxes);

  @override
  List<Object> get props => [checkboxes];
}
