import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import './chart_bar.dart';
// import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List recentTransactions;

  Chart({required this.recentTransactions});

  List get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

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
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + element['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      shadowColor: Colors.pink.shade100,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupedTransactionValues.map((data) {
            return ChartBar(data['day'], data['amount'],
                totalSpending == 0 ? 0.0 : data['amount'] / totalSpending);
          }).toList(),
        ),
      ),
      elevation: 6,
      margin: EdgeInsets.all(10),
    );
  }
}
