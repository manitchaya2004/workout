import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:manitchaya/workout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFf6f0d0),
      // appBar: AppBar(
      //   backgroundColor:  Color.fromARGB(255, 176, 12, 48),
      //   toolbarHeight: 80,
      // ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()  // ถ้ากำลังโหลดแสดง CircularProgressIndicator
            : Text( 'Workout\nwith me' ,style: TextStyle(color: Color.fromARGB(255, 176, 12, 48), fontSize: 40, fontWeight: FontWeight.w700), ),
      ),
      bottomNavigationBar: Container(
        color:  Color.fromARGB(255, 176, 12, 48),
        height: 60,
        child: TextButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;  
            });

            
            await Future.delayed(Duration(seconds: 1));  

          
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => workoutScreen()),
            );

            // หลังจากไปหน้าใหม่แล้ว ให้ตั้งค่าการโหลดเป็น false
            setState(() {
              _isLoading = false;
            });
          },
          child: Text('Start' ,style: TextStyle(color: Color(0xFFf6f0d0), fontSize: 18, fontWeight: FontWeight.w500),),
        ),
      ),
    );
  }
}
