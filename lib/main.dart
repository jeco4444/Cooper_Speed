import 'dart:async';
import 'dart:math';

import 'package:cooper_speed/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Impedisce la rotazione in modalità portrait
    ]);
  runApp(MyApp());
  KeepScreenOn.turnOn();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loaded = false;

  bool _visible = true;

  @override
  void initState() {
    setOptimalDisplayMode();
    super.initState();
  }

  void _animation() async {
    setState(() {
      _visible = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      loaded = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _visible = true;
    });
  }

  Widget r() {
    if (!loaded) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chooseRandomString(),
            style: const TextStyle(
              fontFamily: 'SF-Pro',
              color: Color(0xFF2198F3),
              fontSize: 17,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20,),
          const CircularProgressIndicator(
            color: Color(0xFF2198F3),
          ),
        ],
      );
    } else {
      return StopwatchScreen();
    }
  }

  void setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported.where(
            (DisplayMode m) => m.width == active.width
                && m.height == active.height).toList()..sort(
            (DisplayMode a, DisplayMode b) =>
                b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty
        ? sameResolution.first
        : active;

    /// This setting is per session.
    /// Please ensure this was placed with `initState` of your root widget.
    await FlutterDisplayMode.setPreferredMode(mostOptimalMode);

    _animation();
  }

  String chooseRandomString() {
    String n1 = 'Cronometrando...';
    String n2 = 'Fasciando caviglie...';
    String n3 = 'Calcolando velocità...';
    String n4 = 'Spazzando il campo dal vomito...';
    final List<String> strings = [n1, n2, n3, n4];
    final Random random = Random();
    final int index = random.nextInt(strings.length);
    return strings[index];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('it'),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      home: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: r()
        ),
      ),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State {
  Stopwatch _stopwatch = Stopwatch();
  Stopwatch _Totalstopwatch = Stopwatch();
  Map<int, String> laps = {};
  int CurrentTimeLap = 0;
  TextEditingController _distanceController = TextEditingController();
  double distanceInMeters = 0;
  late Timer _timer;
  int currentLap = 0;
  bool ok = true;


  @override
  void initState() {
    super.initState();
    // Inizializzazione del timer con intervallo di 100 millisecondi
    _timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      setState(() {
        // Aggiornamento dello stato del widget
      });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: 50,
            child: TextField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                distanceInMeters = double.tryParse(value) ?? 0;
              },
              cursorHeight: 30,
              cursorColor: Color(0xFF2198F3),
              style: const TextStyle(
                color: Color(0xFF2198F3),
                fontSize: 25,
              ),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2198F3)),
                ),
                labelText: 'Metri',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                floatingLabelStyle: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF2198F3),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),
        ),
      ],
      toolbarHeight: 100,
      backgroundColor: Colors.black,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Center(
        child: Text('Cooper Speed',
          style: GoogleFonts.urbanist(
            textStyle: const TextStyle(
              color: Color(0xFF2198F3),
              fontSize: 30,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
          )
        ),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100,),
          Center(
            child: SizedBox(
              width: 290,
              child: Text(
                'Totale: ${formatTime(_Totalstopwatch.elapsedMilliseconds)}',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  textStyle: const TextStyle(
                    color: Color(0xFF2198F3),
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 290,
              child: Text(
                'Giro: ${formatTime(_stopwatch.elapsedMilliseconds)}',
                textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  textStyle: const TextStyle(
                    color: Color(0xFF2198F3),
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                )
              ),
            ),
          ),
          const SizedBox(height: 20,),
          Center(
            child: SizedBox(
              width: 290,
              child: Text(
              'Velocità: ${calculateSpeed()} km/h',
              textAlign: TextAlign.left,
                style: GoogleFonts.urbanist(
                  textStyle: const TextStyle(
                    color: Color(0xFF2198F3),
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                )
            ),
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ZoomTapAnimation(
                onTap: () {
                  setState(() {
                    if (_stopwatch.isRunning) {
                      showDialog(context: context, useRootNavigator: false, builder: (context) {
                        return confirm_dialog(
                          IconColor: Colors.red, 
                          funzione: () {
                            _stopwatch.stop();
                            _Totalstopwatch.stop();
                          },
                          icon: Icons.error_outline,
                          text: 'Confermi di voler FERMARE i cronometri?',
                        );
                      });
                      
                    } else {
                      _stopwatch.start();
                      _Totalstopwatch.start();
                    }
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF2198F3)
                  ),
                  child: Icon( _stopwatch.isRunning ? Icons.stop : Icons.play_arrow, color: Colors.black, size: 30,),
                ),
              ),
              ZoomTapAnimation(
                onTap: () {
                  showDialog(context: context, useRootNavigator: false, builder: (context) {
                    return confirm_dialog(
                      IconColor: Colors.red, 
                      funzione: () {
                        setState(() {
                          _stopwatch.reset();
                          _Totalstopwatch.reset();
                          CurrentTimeLap = 0;
                          laps.clear();
                          currentLap = 0;
                          ok = true;
                        });
                      },
                      icon: Icons.error_outline,
                      text: 'Confermi di voler AZZERARE i cronometri e i giri?',
                    );
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF2198F3)
                  ),
                  child: Icon(Icons.restart_alt_rounded, color: Colors.black, size: 30,),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Center(
            child: ZoomTapAnimation(
              onTap: () {
                setState(() {
                  if (!_stopwatch.isRunning && ok == false) {}
                  else if (!_stopwatch.isRunning && ok == true) {
                    ok = false;
                    CurrentTimeLap = _stopwatch.elapsedMilliseconds;
            
                    _stopwatch.reset();
            
                    currentLap = currentLap + 1;
            
                    String lapTime = 'Tempo: ${formatTime(CurrentTimeLap)} - Velocità: ${calculateSpeed()}';
                    laps.addAll({currentLap : lapTime});
                  } else {
                    CurrentTimeLap = _stopwatch.elapsedMilliseconds;
            
                    _stopwatch.reset();
            
                    currentLap = currentLap + 1;
            
                    String lapTime = 'Tempo: ${formatTime(CurrentTimeLap)} - Velocità: ${calculateSpeed()}';
                    laps.addAll({currentLap : lapTime});
                  }
                });
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF2198F3)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.label_important_outline_rounded, color: Colors.black, size: 30,),
                    const SizedBox(width: 15,),
                    Text(
                      'GIRO',
                      style: GoogleFonts.urbanist(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  Text(
                    'GIRI:',
                    style: GoogleFonts.urbanist(
                      textStyle: const TextStyle(
                        color: Color(0xFF2198F3),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: laps.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: GoogleFonts.urbanist(
                          textStyle: const TextStyle(
                            color: Color(0xFF2198F3),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  String formatTime(int m) {
    String milliseconds = (m % 1000).toString().padLeft(3, "0"); // this one for the miliseconds
    String seconds = ((m ~/ 1000) % 60).toString().padLeft(2, "0"); // this is for the second
    String minutes = ((m ~/ 1000) ~/ 60).toString().padLeft(2, "0"); // this is for the minute
 
    return "$minutes:$seconds:$milliseconds";
  }

  String calculateSpeed() {
    if (distanceInMeters <= 0 || CurrentTimeLap == 0) {
      return '0';
    }
    double speed = (distanceInMeters / 1000) / (CurrentTimeLap / 3600000);
    return speed.toStringAsFixed(2);
  }

  @override
  void dispose() {
    // Disposizione del timer quando lo stato viene eliminato
    _timer.cancel();
    _stopwatch.stop();
    _Totalstopwatch.stop();
    _distanceController.dispose();
    super.dispose();
  }
}

