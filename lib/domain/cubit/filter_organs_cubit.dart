import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:psychosomatics/presentation/widgets/alert_dialog_filter.dart';

part 'filter_organs_state.dart';

class FilterOrgansCubit extends Cubit<FilterOrgansState> {
  final Map<Organ, bool> checkboxes;

  FilterOrgansCubit(this.checkboxes) : super(const FilterOrgansState({}));

// void doAction(FilterActions action, Organ organ) {
//   switch (action) {
//     case FilterActions.check:
//
//   }
// }

  void changeCheckbox(Organ organ, bool isChecked) {
    checkboxes[organ] = isChecked;

    //emit(FilterOrgansState(action, organ));

    // cardsExpand[weekDay.toString()]['isExpanded'] = isExpand;
    //
    // if (isExpand) {
    //   cardsExpand[weekDay.toString()]['height'] = 140.0;
    // } else {
    //   cardsExpand[weekDay.toString()]['height'] = 70.0;
    // }
    //
    // if (state is CardExpansionInitial) {
    //   emit(CardExpansionExpanded(cardsExpand: cardsExpand));
    // } else if (state is CardExpansionExpanded) {
    //   emit(CardExpansionNarrowed(cardsExpand: cardsExpand));
    // } else if (state is CardExpansionNarrowed) {
    //   emit(CardExpansionExpanded(cardsExpand: cardsExpand));
    // }
  }
}
