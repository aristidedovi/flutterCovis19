import 'dart:developer';
import 'dart:ui';

import 'package:covid/constant.dart';
import 'package:covid/models/countrie_models.dart';
import 'package:covid/services/http_service.dart';
import 'package:covid/widgets/chart.dart';
import 'package:covid/widgets/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'widgets/my_header.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'COVID-19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBlackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
              body1: TextStyle(
            color: kBodyTextColor,
          ))),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HttpService httpService = HttpService();

  var dropdownValue = 'togo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COVID-19"),
        backgroundColor: Color(0xFF3383CD),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Restez chez vous",
              textBottom: "Sauvez des vies",
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Color(0xFFE5E5E5)),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: FutureBuilder(
                        future: httpService.getCountries(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List> snapshot) {
                          List countriesList = snapshot.data;
                          //print(snapshot.data);
                          return DropdownButton(
                            hint: Text("Select item"),
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: SvgPicture.asset('assets/icons/dropdown.svg'),
                            value: dropdownValue,
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value;
                              });
                            },
                            items: [
                              'togo',
                              'senegal',
                              'mali',
                              'guinea',
                              'burkina faso',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          );
                        }),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FutureBuilder(
                            future: httpService.getPosts(dropdownValue),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Countrie>> snapshot) {
                              List<Countrie> countries = snapshot.data;
                              if (countries == null) {
                                return SizedBox(height: 20);
                              } else {
                                return RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Mise à jour\n',
                                        style: kTitleTextStyle,
                                      ),
                                      TextSpan(
                                        text: 'Date : ' +
                                            countries[countries.length - 1]
                                                .date,
                                        style: TextStyle(
                                          color: kTextLightColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                      ),
                      Spacer(),
                      Text(
                        'voir plus',
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: FutureBuilder(
                              future: httpService.getPosts(dropdownValue),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Countrie>> snapshot) {
                                List<Countrie> countries = snapshot.data;
                                if (countries == null) {
                                  return SizedBox(height: 20);
                                } else {
                                  return Counter(
                                    color: kInfectedColor,
                                    number: countries[countries.length - 1]
                                        .confirmed,
                                    title: 'Actifs',
                                  );
                                }
                              }),
                        ),
                        Expanded(
                          child: FutureBuilder(
                              future: httpService.getPosts(dropdownValue),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Countrie>> snapshot) {
                                List<Countrie> countries = snapshot.data;
                                if (countries == null) {
                                  return SizedBox(height: 20);
                                } else {
                                  return Counter(
                                    color: kDeathColor,
                                    number:
                                        countries[countries.length - 1].deaths,
                                    title: 'Décès',
                                  );
                                }
                              }),
                        ),
                        Expanded(
                          child: FutureBuilder(
                              future: httpService.getPosts(dropdownValue),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Countrie>> snapshot) {
                                List<Countrie> countries = snapshot.data;
                                if (countries == null) {
                                  return SizedBox(height: 20);
                                } else {
                                  return Counter(
                                    color: kRecoverColor,
                                    number: countries[countries.length - 1]
                                        .recovered,
                                    title: 'Guéris',
                                  );
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Propagation du virus",
                        style: kTitleTextStyle,
                      ),
                      Text(
                        "Voir plus",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child:
                        /*FutureBuilder(
                        future: httpService.getPosts(dropdownValue),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Countrie>> snapshot) {
                          List<Countrie> countries = snapshot.data;
                          if (countries == null) {
                            return SizedBox(height: 20);
                          } else {
                            return  PatternForwardHatchBarChart(countries);
                          }
                        }),*/

                        Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.contain,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
