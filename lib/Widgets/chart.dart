import 'package:expense_app/Widgets/barchart.dart';
import 'package:expense_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      //print(DateFormat.E().format(weekDay));
      //print(totalSum);

      return {
        'day': DateFormat('EEE').format(weekDay).substring(0, 3),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransactionValue.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                          child: BarChart(
                  data['day'], 
                  data['amount'],
                  totalSpending == 0.0 
                  ? 0.0 
                    : (data['amount'] as double) / totalSpending,
                    ),
              );
            }).toList(),
          ),
        ),
    );
  }
}
