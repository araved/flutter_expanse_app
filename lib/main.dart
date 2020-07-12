import 'dart:io';
import 'package:expense_app/Widgets/chart.dart';
import 'package:expense_app/Widgets/newtransaction.dart';
import 'package:expense_app/Widgets/transactionlist.dart';
import 'package:flutter/cupertino.dart';
import './models/transaction.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

Widget _iOS(BuildContext context){
  return CupertinoApp(
            title: 'Personal Expenses',
            localizationsDelegates: [
              DefaultMaterialLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
            ],
            theme: CupertinoThemeData(
              primaryColor: CupertinoColors.darkBackgroundGray,
              barBackgroundColor: CupertinoColors.activeBlue,
              //fontFamily: 'Aller',
              textTheme: CupertinoTextThemeData(
                primaryColor: CupertinoColors.activeOrange,
                navTitleTextStyle: TextStyle(
                    fontFamily: 'Aller',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: CupertinoTheme.of(context).primaryContrastingColor),
                navLargeTitleTextStyle: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: CupertinoTheme.of(context).barBackgroundColor),
              ),
            ),
            home: MyHomePage(),
          );
}

Widget _isAndroid(BuildContext context){
  return MaterialApp(
            title: 'Personal Expenses',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.blue,
                fontFamily: 'Aller',
                textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).accentColor)),
                appBarTheme: AppBarTheme(
                    textTheme: ThemeData.light().textTheme.copyWith(
                        title: TextStyle(
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 20)))),
            home: MyHomePage(),
          );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? _iOS(context)
        : _isAndroid(context);
  }
}

class MyHomePage extends StatefulWidget {
  //String titleInput;
  //String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransaction = [
    //Transaction(
    //id: 't1', title: 'Car Repair', amount: 372, date: DateTime.now()),
    // Transaction(id: 't2', title: 'McD', amount: 26, date: DateTime.now())
  ];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTX = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransaction.add(newTX);
    });
  }

  void _startAddNewTx(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        builder: (_) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              child: Wrap(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      // FocusScopeNode currentFocus = FocusScope.of(context);
                      // if (!currentFocus.hasPrimaryFocus &&
                      // currentFocus.focusedChild != null) {
                      // currentFocus.focusedChild.unfocus();
                      // }
                    },
                    child: NewTransaction(_addNewTransaction),
                    //behavior: HitTestBehavior.opaque,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Show Chart'),
            Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              },
            )
          ],
        ),
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.9,
              child: Chart(_recentTransactions))
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense Tracker'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              CupertinoButton(
                  child: Icon(CupertinoIcons.add_circled),
                  onPressed: () => _startAddNewTx(context))
            ]),
          )
        : AppBar(
            title: Text('Expense Tracker'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _startAddNewTx(context))
            ],
          );
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransaction, _deleteTransaction));
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTx(context),
                  ),
          );
  }
}
