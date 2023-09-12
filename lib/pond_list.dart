// import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:water_quality_monitoring_system/CommonWidget/CommonWidget.dart';
import 'package:water_quality_monitoring_system/Pond/EditPond.dart';
import 'package:water_quality_monitoring_system/water_quality.dart';

class PondList extends StatefulWidget {
  final String token;
  const PondList({Key? key , required this.token}) : super(key: key);

  @override
  State<PondList> createState() => _PondListState(token : token);
}

class _PondListState extends State<PondList> {

  final String? token;

  _PondListState({
    required this.token,
  }
      );
  bool isLoading = true;

  List<Map<String, dynamic>> getAllPond = [];

  Future<void> fetchPondData() async {
    final response = await http.get(
      Uri.parse('http://182.163.112.102:8007/api/pond/list/'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print("fetch done");
      final jsonData = json.decode(response.body);
      setState(() {
        getAllPond = List<Map<String, dynamic>>.from(jsonData['data']);
        print("POND PAGE : $getAllPond");
      });
    } else {
      // Handle error cases
      print('Failed to fetch pond data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPondData().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  reloadPage(){
    setState(() {

    });
  }




  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
          title: Text('Pond/Tank List'),
        actions: [

        ],
      ),
      body: isLoading?
      Center(
        child: Loading(),
      )
          :ListView.builder(
        itemCount: getAllPond.length,
        itemBuilder: (context, index) {
          final pond = getAllPond[index];
          return

             Dismissible(
               key: UniqueKey(),
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                 onDismissed: (direction) async {
                final pondId = pond['id'];
                 final response = await http.delete(
                 Uri.parse('http://182.163.112.102:8007/api/pond/delete/$pondId/'),
                   headers: {
                 'Authorization': 'Bearer $token',
                 'Content-Type': 'application/json',
             },
             );

          if (response.statusCode == 200) {
            setState(() {
              // Remove the pond from the list after successful deletion
              getAllPond.removeAt(index);
            });
          } else {
            // Handle error in deletion
          }
        },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListTile(
                  title: Text(pond['name'],style: TextStyle(fontSize: 20),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Depth: ${pond['depth']} m, Area: ${pond['area']} m2',),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFormDemo(
                                    editPondData: pond,
                                    token: widget.token,
                                    onEditSuccess: (bool isSuccess) {
                                      isLoading =true;
                                      setState(() {});
                                      print("A Aaaaaaaa");
                                      fetchPondData().then((value) => isLoading =false);
                                      setState(() {}); // Pop with the value
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          Text("Edit"),

                          IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.delete_sweep),
                          ),

                          Text("Delete"),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    print(pond);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WaterQuality(token: '$token',pondId : pond['id']),));
                  },
            ),
               ),
             );
        },
      ),



      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController _pondName = TextEditingController();
          TextEditingController _pondDepth = TextEditingController();
          TextEditingController _pondArea = TextEditingController();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text('Add New Pond/Tank'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _pondName,
                          decoration: InputDecoration(
                            hintText: 'Pond/Tank Name',
                          ),
                        ),
                        TextField(
                          controller: _pondDepth,
                          decoration: InputDecoration(
                            hintText: 'Pond Depth(meter)',
                          ),
                        ),
                        TextField(
                          controller: _pondArea,
                          decoration: InputDecoration(
                            hintText: 'Pond Area(square meter)',
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pondName = _pondName.text;
                          final pondDepth = double.parse(_pondDepth.text);
                          final pondArea = double.parse(_pondArea.text);
                          final pondData = {
                            "name": pondName,
                            "depth": pondDepth,
                            "area": pondArea,
                          };

                          final response = await http.post(
                            Uri.parse('http://182.163.112.102:8007/api/pond/create/'),
                            headers: {
                              'Authorization': 'Bearer $token',
                              'Content-Type': 'application/json',
                            },
                            body: json.encode(pondData),
                          );

                          if (response.statusCode == 201) {
                            print("????????????????????????????????????????");
                            Map<String,dynamic>message=json.decode(response.body);
                            ToastMessage.show(context,message["message"].toString());


                            print("????????????????????????????????????????");
                            // Pond successfully added, update UI
                            fetchPondData().then((_) {
                              setState(() {});
                            });
                            Navigator.pop(context);
                          } else {
                            // Handle error cases
                            print('Failed to add pond');
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        child: Icon(Icons.add, color: Colors.cyan),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Container(height: 50,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );
  }
}





















