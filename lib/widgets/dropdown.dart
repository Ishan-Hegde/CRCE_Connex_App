import 'package:flutter/material.dart';

class Dropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<T> items;
  final void Function(T?) onChanged;

  const Dropdown({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: key,
      borderRadius: BorderRadius.circular(16),
      isExpanded: true,
      isDense: true,
      dropdownColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(.5)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.surface,
          ),
        ), // Cor de fundo do menu suspenso
      ),
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: SizedBox(
            child: Text(
              item.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
