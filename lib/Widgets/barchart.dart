import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BarChart extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercent;

  BarChart(this.label, this.spendingAmount,this.spendingPercent);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraint) {
       return Column(
      children: <Widget>[
        Container(
          height: constraint.maxHeight*0.15,
          child: FittedBox(
            child: Text('RM ${spendingAmount.toStringAsFixed(0)}'),
            ),
        ),
        SizedBox(
          height: constraint.maxHeight *0.05,),
        Container(
          height: constraint.maxHeight *0.6,
          width: 10,
          child: Stack(
            children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.0),
                color: Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.circular(10) ),
            ),
            FractionallySizedBox(
              heightFactor: spendingPercent, 
              child: Container(
                decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(10)
                ),
            ),
            )
          ],
          ),
        ),
        SizedBox(
          height: constraint.maxHeight *0.05,
        ),
        Container(
          height: constraint.maxHeight*0.15,
          child: FittedBox(child: Text(label)))
      ],
    );
    });
  }
}