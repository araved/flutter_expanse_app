import 'package:expense_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;

  TransactionList(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No Transactions added yet!!',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'Assets/Images/waiting.png',
                      fit: BoxFit.contain,
                    ))
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
                        child: Text(
                          'RM ${transaction[index].amount}',
                        ),
                      ),
                    ),
                  ),
                  title: Text('${transaction[index].title}',
                      style: Theme.of(context).textTheme.title),
                  subtitle: Text(DateFormat('E, dd/MMMM/yyyy')
                      .format(transaction[index].date)
                      .toString()),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? FlatButton.icon(
                          onPressed: () => deleteTx(transaction[index].id),
                          icon: Icon(Icons.delete),
                          textColor: Theme.of(context).errorColor,
                          label: Text('Delete',))
                      : IconButton(
                          icon: Icon(CupertinoIcons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteTx(transaction[index].id)),
                ),
              );
            },
            itemCount: transaction.length,
          );
  }
}
