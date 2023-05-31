import 'package:billsplit_flutter/presentation/common/base_bloc_builder.dart';
import 'package:billsplit_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../../common/rounded_list_item.dart';
import '../bloc/add_expense_bloc.dart';
import 'expense_currency.dart';

class ExpenseTotalView extends StatelessWidget {
  const ExpenseTotalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBlocBuilder<AddExpenseBloc>(
      builder: (cubit, state) {
        return Row(
          children: [
            Expanded(
              child: RoundedListItem(
                height: 64,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10), right: Radius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: Theme.of(context).textTheme.labelSmall),
                    Text(
                      cubit.groupExpense.total.fmt2dec(),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            const SizedBox(
                width: 64,
                height: 64,
                child: ExpenseCurrencyButton(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10), right: Radius.circular(10)),
                ))
          ],
        );
      }
    );
  }
}
