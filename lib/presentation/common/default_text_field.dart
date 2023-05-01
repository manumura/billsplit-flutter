import 'package:billsplit_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class ExpenseTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final void Function(num) onChange;
  final bool canBeZero;
  final bool autoFocus;
  final num? maxValue;

  ExpenseTextField({
    Key? key,
    required this.textEditingController,
    required this.onChange,
    this.canBeZero = true,
    this.autoFocus = false,
    this.maxValue,
  }) : super(key: key) {
    textEditingController.addListener(() {
      onChange(parseInput);
      _onChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autoFocus,
      maxLength: 7,
      textAlign: TextAlign.end,
      maxLines: 1,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        isDense: true,
        hintText: "0",
        border: InputBorder.none,
        errorText: _errorText(),
        prefixIcon: const Icon(Icons.attach_money_outlined),
        counterText: "",
        prefixIconConstraints: const BoxConstraints(),
        suffix: maxValue != null
            ? TextButton(
                onPressed: () {
                  textEditingController.text = maxValue!.fmt2dec();
                  textEditingController.selection = TextSelection.collapsed(
                      offset: textEditingController.text.length);
                },
                child: const Text("max"),
              )
            : null,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  String? _errorText() {
    final text = textEditingController.text;
    if (text.isEmpty) return "Enter a number";
    try {
      final number = num.parse(text);
      if (!canBeZero && number == 0) return "Expense is 0";
      if (number < 0) return "Input < 0";
      return null;
    } catch (e) {
      return "Invalid input";
    }
  }

  num get parseInput {
    final text = textEditingController.text;
    num inputAsNumber = 0;
    try {
      final input = num.parse(text);
      if (input < 0) {
        inputAsNumber = 0;
      } else if (input > maxInput) {
        inputAsNumber = maxInput;
      } else {
        inputAsNumber = input;
      }
    } catch (e) {
      print("$e: $inputAsNumber");
      inputAsNumber = 0;
    }
    return inputAsNumber;
  }

  String get text => textEditingController.text;
  set text(String text) => textEditingController.text = text;

  void _onChange() {
    if (text == "0") {
      text = "";
      textEditingController.selection =
          TextSelection.collapsed(offset: text.length);
    }
    if (maxValue != null &&
        parseInput > (maxValue ?? 0) &&
        (parseInput.fmt2dec() != maxValue!.fmt2dec() ||
            text.length > maxValue!.fmt2dec().length)) {
      text = maxValue!.fmt2dec();
      textEditingController.selection =
          TextSelection.collapsed(offset: text.length);
    }
    if (text.contains(",")) {
      text = text.replaceAll(",", ".");
      textEditingController.selection =
          TextSelection.collapsed(offset: text.length);
    }
  }

  static const maxInput = 9999999.99; // max 7 chars + 2 decimals
}
