import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/header.dart';
import '../../widgets/input.dart';
import '../../widgets/dropdown.dart';

class App09 extends StatefulWidget {
  const App09({Key? key}) : super(key: key);

  @override
  App09UI createState() => App09UI();
}

class App09UI extends State<App09> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedFromCurrency = 'Real (BRL)';
  String _selectedToCurrency = 'Dollar (USD)';
  String _result = '-';

  final Map<String, double> _exchangeRates = {
    'Real (BRL)': 1.0,
    'Dollar (USD)': 5.14,
    'Euro (EUR)': 5.43,
  };

  void _convertCurrency() {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    double fromCurrencyRate = _exchangeRates[_selectedFromCurrency] ?? 1.0;
    double toCurrencyRate = _exchangeRates[_selectedToCurrency] ?? 1.0;

    double result = (amount * fromCurrencyRate) / toCurrencyRate;

    setState(() {
      _result =
          NumberFormat.currency(symbol: '', decimalDigits: 2).format(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String title = args?['title'] ?? 'Default Title';

    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        header(context, title),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Input(
                controller: _amountController,
                labelText: 'Amount',
                hintText: 'Fill the amount to be converted',
                keyboardType: TextInputType.number),
            const SizedBox(height: 24),
            Dropdown<String>(
              labelText: 'From',
              value: _selectedFromCurrency,
              items: _exchangeRates.keys
                  .map((currency) => currency.toString())
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFromCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),
            Dropdown<String>(
              labelText: 'To',
              value: _selectedToCurrency,
              items: _exchangeRates.keys
                  .map((currency) => currency.toString())
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedToCurrency = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: const Text('Convert'),
            ),
          ]),
        ),
        const SizedBox(height: 40),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surface),
          child: Text(
            _result,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    )));
  }
}
