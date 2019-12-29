import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crypto_calculator_flutter/calculator_model.dart';

class Rate {
  final String base;
  final String crypto;
  final double value;

  Rate(this.base, this.crypto, this.value);

  Rate.fromJson(Map<String, dynamic> json)
      : base = json['base'],
        crypto = json['crypto'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
        'base': base,
        'crypto': crypto,
        'value': value,
      };
}

void main() => runApp(CryptoCalculatorApp());

class CryptoCalculatorApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => CalculatorModel(),
        child: CalculatorPage(),
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with WidgetsBindingObserver {
  static final defaultDirection = Direction.forward;
  static final defaultAmount = 0.0;
  static final spacingRatio = 12.0;
  String base;
  String crypto;
  static const apiChannel = const BasicMessageChannel<dynamic>(
      'crypto_calculator', JSONMessageCodec());
  final FocusNode textFieldFocusNode = FocusNode();
  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();

    apiChannel.setMessageHandler((dynamic message) async {
      var rate = Rate.fromJson(message as Map);
      setState(() {
        base = rate.base;
        crypto = rate.crypto;
      });

      _textFieldController.text = "";
      final calculatorModel =
          Provider.of<CalculatorModel>(context, listen: false);
      calculatorModel.direction = defaultDirection;
      calculatorModel.amount = defaultAmount;
      calculatorModel.rate = rate.value;
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        FocusScope.of(context).unfocus();
        break;
      case AppLifecycleState.resumed:
        FocusScope.of(context).requestFocus(textFieldFocusNode);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      child: Consumer<CalculatorModel>(
        builder: (context, model, _) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: screenSize.width / spacingRatio, bottom: screenSize.width / spacingRatio),
                  child: Text(
                    "$crypto / $base",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "${model.rate}",
                              style: TextStyle(fontSize: 25),
                            ),
                            Spacer(),
                            CupertinoTextField(
                              style: TextStyle(fontSize: 25),
                              textAlign: TextAlign.center,
                              decoration: null,
                              focusNode: textFieldFocusNode,
                              controller: _textFieldController,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              onChanged: (text) {
                                model.amount = text.length >
                                        0
                                    ? double.parse(text.replaceAll(',', '.'))
                                    : 0.0;
                              },
                            ),
                            Container(
                              height: 1.0,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "${(model.direction == Direction.forward) ? base : crypto}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 50.0, height: 50.0),
                              child: CupertinoButton(
                                onPressed: () {
                                  model.direction =
                                      (model.direction == Direction.forward)
                                          ? Direction.reverse
                                          : Direction.forward;
                                },
                                child: Image(
                                    image:
                                        AssetImage('assets/up-down-arrow.png')),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "${(model.direction == Direction.forward) ? crypto : base}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text("${model.totalAmount}",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w200,
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
