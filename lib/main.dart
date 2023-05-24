import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Lamp Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LampControlPage(),
    );
  }
}

class LampControlPage extends StatefulWidget {
  @override
  _LampControlPageState createState() => _LampControlPageState();
}

class _LampControlPageState extends State<LampControlPage> {
  late DatabaseReference lamp1Ref;
  late DatabaseReference lamp2Ref;

  @override
  void initState() {
    super.initState();
    lamp1Ref =
        FirebaseDatabase.instance.ref().child('lamp_control').child('lamp1');
    lamp2Ref =
        FirebaseDatabase.instance.ref().child('lamp_control').child('lamp2');
  }

  void updateLampStatus(DatabaseReference lampRef, String status) {
    lampRef.set(status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lamp Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lamp 1',
              style: TextStyle(fontSize: 24),
            ),
            StreamBuilder<DatabaseEvent>(
              stream: lamp1Ref.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  String lampStatus =
                      snapshot.data!.snapshot.value.toString() ?? 'off';
                  return Text(
                    'Status: $lampStatus',
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateLampStatus(lamp1Ref, 'on'),
              child: Text('Turn On'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateLampStatus(lamp1Ref, 'off'),
              child: Text('Turn Off'),
            ),
            SizedBox(height: 40),
            Text(
              'Lamp 2',
              style: TextStyle(fontSize: 24),
            ),
            StreamBuilder<DatabaseEvent>(
              stream: lamp2Ref.onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  String lampStatus =
                      snapshot.data!.snapshot.value.toString() ?? 'off';
                  return Text(
                    'Status: $lampStatus',
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateLampStatus(lamp2Ref, 'on'),
              child: Text('Turn On'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => updateLampStatus(lamp2Ref, 'off'),
              child: Text('Turn Off'),
            ),
          ],
        ),
      ),
    );
  }
}
