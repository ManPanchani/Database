import 'dart:typed_data';
import 'package:demo1/homeScreens/helpers/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future getData;

  final GlobalKey<FormState> insertKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController upNameController = TextEditingController();
  TextEditingController upCityController = TextEditingController();

  Uint8List? image;
  String? name;
  String? city;

  Uint8List? upImage;
  String? upName;
  String? upCity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: DbHelper.dbHelper.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("ERROR: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            List<Map<String, dynamic>>? data = snapshot.data;

            return ListView.builder(
              itemCount: data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("UPDATE DATA"),
                          content: SizedBox(
                            height: 320,
                            child: Form(
                              key: updateKey,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      XFile? xFile =
                                          await imagePicker.pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 70);
                                      upImage = await xFile!.readAsBytes();
                                      setState(() {
                                        upImage;
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: (upImage != null)
                                          ? MemoryImage(upImage!)
                                          : null,
                                      child: const Text("Add Image"),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      return (value!.isEmpty)
                                          ? "Enter Name Updated Data..."
                                          : null;
                                    },
                                    onSaved: (val) {
                                      upName = val;
                                    },
                                    controller: upNameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      return (value!.isEmpty)
                                          ? "Enter City Updated Data..."
                                          : null;
                                    },
                                    onSaved: (val) {
                                      upCity = val;
                                    },
                                    controller: upCityController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      if (updateKey.currentState!.validate()) {
                                        updateKey.currentState!.save();

                                        int item =
                                            await DbHelper.dbHelper.updateData(
                                          id: data[index]['id'],
                                          name: upName,
                                          city: upCity,
                                          image: upImage,
                                        );

                                        print("=================");
                                        print(item);
                                        print("=================");

                                        if (item == 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "Data Successfully Updated...")));

                                          setState(() {
                                            getData =
                                                DbHelper.dbHelper.fetchData();

                                            upNameController.clear();
                                            upCityController.clear();

                                            upName = null;
                                            upCity = null;
                                          });

                                          Get.back();
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Updated Data Failed...")));

                                        setState(() {
                                          upNameController.clear();
                                          upCityController.clear();

                                          upName = null;
                                          upCity = null;
                                        });
                                        Get.back();
                                      }
                                    },
                                    child: const Text("Update")),
                                OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        upNameController.clear();
                                        upCityController.clear();

                                        upName = null;
                                        upCity = null;
                                      });

                                      Get.back();
                                    },
                                    child: const Text("Close")),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Data"),
                          content: const Text("Are You Sure Data Deleted ?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                int item = await DbHelper.dbHelper
                                    .deleteData(id: data[index]['id']);

                                print("--------------------------");
                                print(item);
                                print("--------------------------");

                                if (item == 1) {
                                  setState(() {
                                    getData = DbHelper.dbHelper.fetchData();
                                  });
                                }
                                Get.back();
                              },
                              child: const Text("Delete"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: ListTile(
                    isThreeLine: true,
                    leading: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade300,
                        image: DecorationImage(
                          image: MemoryImage(
                            data[index]['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      "${data[index]['name']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      "City: ${data[index]['city']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("INSERT DATA"),
                content: SizedBox(
                  height: 300,
                  child: Form(
                    key: insertKey,
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            XFile? xFile = await imagePicker.pickImage(
                                source: ImageSource.camera, imageQuality: 70);
                            image = await xFile!.readAsBytes();
                            setState(() {
                              image = image;
                            });
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                (image != null) ? MemoryImage(image!) : null,
                            child: const Text("Add Image"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: nameController,
                          onSaved: (val) {
                            name = val;
                          },
                          validator: (val) {
                            return (val!.isEmpty) ? "Enter the Name..." : null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter the Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: cityController,
                          onSaved: (val) {
                            city = val;
                          },
                          validator: (val) {
                            return (val!.isEmpty) ? "Enter the City..." : null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Enter the City",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        if (insertKey.currentState!.validate()) {
                          insertKey.currentState!.save();

                          int id = await DbHelper.dbHelper.insertData(
                              name: name!, city: city!, image: image);

                          print("========================");
                          print(id);
                          print("========================");

                          if (id > 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Insert Data Successfully Inserted..."),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            setState(() {
                              getData = DbHelper.dbHelper.fetchData();

                              nameController.clear();
                              cityController.clear();

                              name = null;
                              city = null;
                              image = null;
                            });
                            Get.back();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Insert Data failed..."),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text("Insert")),
                  const SizedBox(
                    height: 50,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        setState(() {
                          nameController.clear();
                          cityController.clear();

                          name = null;
                          city = null;
                          image = null;
                        });
                        Get.back();
                      },
                      child: const Text("Close")),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
