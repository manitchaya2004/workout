import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class workoutScreen extends StatefulWidget {
  const workoutScreen({super.key});

  @override
  State<workoutScreen> createState() => _workoutScreenState();
}

class _workoutScreenState extends State<workoutScreen> {
  final activityName = TextEditingController();
  final time = TextEditingController();
  double userWeight = 49;

  CollectionReference workoutCollection =
      FirebaseFirestore.instance.collection('Workout');

  double calculateCalories(String activity, int minutes, double weight) {
    double met = getMET(activity);
    return (met * weight * (minutes / 60)).roundToDouble();
  }

  

  // ไว่คำนวณ calll
  double getMET(String activity) {
    Map<String, double> metValues = {
      'walking': 3.8,
      'running': 8.0,
      'cardio': 6.8,
      'cycling': 7.5,
      'aerobics': 7.3,
      'swimming': 6.0,
      'hiking': 9.0,
      'yoga': 2.5,
      'football': 7.0,
    };
    return metValues[activity] ?? 3.0;
  }

  // popup เพิ่มข้อมูลจร๊
  void _addWorkout() {
    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFFfff7d8),
          title: Center(
            child: Text('Add Workout'  , style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 0, 0)),),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              TextField(
                controller: nameController,
                decoration:  InputDecoration(
                  hintText: 'Activities',
                  icon: Icon(Icons.fitness_center),
                  border: OutlineInputBorder( // กำหนดขอบเป็น OutlineInputBorder
                  borderRadius: BorderRadius.circular(10), // กำหนดมุมของขอบ
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 0, 0, 0), // สีของขอบ
                    width: 1.0, // ความหนาของขอบ
                  ),
                ),
                filled: true, // ทำให้มีพื้นหลัง
                fillColor:const Color.fromARGB(255, 255, 255, 255), // กำหนดสีพื้นหลัง
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // เพิ่ม padding ให้กับข้อความ
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Duration (minutes)',
                  icon: Icon(Icons.timer),
                  border: OutlineInputBorder( // กำหนดขอบเป็น OutlineInputBorder
                  borderRadius: BorderRadius.circular(10), // กำหนดมุมของขอบ
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 0, 0, 0), // สีของขอบ
                    width: 1.0, // ความหนาของขอบ
                  ),
                ),
                filled: true, // ทำให้มีพื้นหลัง
                fillColor:const Color.fromARGB(255, 255, 255, 255), // กำหนดสีพื้นหลัง
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // เพิ่ม padding ให้กับข้อความ
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int duration = int.tryParse(timeController.text) ?? 0;
                double calories = calculateCalories(
                    nameController.text, duration, userWeight);

                workoutCollection.add({
                  'name': nameController.text,
                  'time': duration,
                  'calories': '${calories.toStringAsFixed(2)} kcal',
                });
                Navigator.pop(context);
              },
              child:  Text('Save' ,style: TextStyle(color: const Color.fromARGB(255, 176, 12, 48)),),
            ),
          ],
        );
      },
    );
  }

  // ลบออกจากฐาน
  void _deleteWorkout(String workoutId) {
    workoutCollection.doc(workoutId).delete();
  }

  // popup แก้ไขจร๊
  void _editWorkout(String workoutId, String oldName, int oldTime) {
  TextEditingController nameController = TextEditingController(text: oldName);
  TextEditingController timeController =
      TextEditingController(text: oldTime.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Color(0xFFfff7d8),
        title: Center(
          child: Text('Edit Workout' , style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color.fromARGB(255, 0, 0, 0)),),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Activities',
                icon: Icon(Icons.fitness_center),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), 
                  borderSide: BorderSide(
                    color:  Color.fromARGB(255, 0, 0, 0), 
                    width: 1.0, 
                  ),
                ),
                filled: true, 
                fillColor: Color.fromARGB(255, 255, 255, 255), 
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), 
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: timeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Duration (minutes)',
                icon: Icon(Icons.timer),
                border: OutlineInputBorder( 
                  borderRadius: BorderRadius.circular(10), 
                  borderSide: BorderSide(
                    color: const Color.fromARGB(255, 0, 0, 0), 
                    width: 1.0, 
                  ),
                ),
                filled: true, // ทำให้มีพื้นหลัง
                fillColor: const Color.fromARGB(255, 255, 255, 255), // กำหนดสีพื้นหลัง
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // เพิ่ม padding ให้กับข้อความ
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              int? duration = int.tryParse(timeController.text);
              if (duration == null || duration <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in the correct time period.')),
                );
                return;
              }

              double calories = calculateCalories(
                  nameController.text, duration.toInt(), userWeight);

              await workoutCollection.doc(workoutId).update({
                'name': nameController.text,
                'time': duration,
                'calories': '${calories.toStringAsFixed(2)} kcal',
              });

              Navigator.pop(context);
            },
            child: const Text('Save' , style: TextStyle(color:   Color.fromARGB(255, 176, 12, 48)),),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 252, 251, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 176, 12, 48),
        title: Text(
            'Workout',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFFf6f0d0)),
          ),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: Column(
        children: [
       
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 255, 255, 255), 
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), 
                    spreadRadius: 2, 
                    blurRadius: 5,
                    offset: Offset(0, 4), 
                  ),
                ]),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/kitty.png'), 
                ),
                SizedBox(width: 16), 

             
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kittyrose', 
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text('weight : ${userWeight} kg',
                        style: TextStyle(fontSize: 16)),
                    Text('height : 157 cm ', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 10), 
          Text('Daily activities'),
          // Expanded สำหรับ StreamBuilder
          Expanded(
            child: StreamBuilder(
              stream: workoutCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('ยังไม่มีการบันทึกข้อมูล',
                          style: TextStyle(fontSize: 16)));
                }
                return ListView(
                  padding: const EdgeInsets.all(10),
                  children: snapshot.data!.docs.map((doc) {
                    return Slidable(
                      key: ValueKey(doc.id),
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _editWorkout(doc.id, doc['name'],
                                int.tryParse(doc['time'].toString()) ?? 0),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'แก้ไข',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion:  DrawerMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) => _deleteWorkout(doc.id),
                            backgroundColor:  Color.fromARGB(255, 176, 12, 48),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'ลบ',
                          ),
                        ],
                      ),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: Image.asset(
                            'assets/images/checklist.png',
                            height: 25,
                          ),
                          title:
                              Text(doc['name'], style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.w500)),
                          subtitle: Text('Healthy body !!!',
                              style: TextStyle(fontSize: 12)),
                          trailing: Text('${doc['calories']}',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: const Color.fromARGB(255, 176, 12, 48),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 176, 12, 48),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: _addWorkout,
      ),
    
    );
  }
}
