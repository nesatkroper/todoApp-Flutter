import 'package:flutter/material.dart';
import 'package:todo_list/db_handler.dart';
import 'package:todo_list/home_screeen.dart';
import 'package:todo_list/model.dart';
import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';

// ignore: must_be_immutable
class AddUpdateTask extends StatefulWidget {
  // const AddUpdateTask({super.key});
  // const AddUpdateTask({super.key});

  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  AddUpdateTask(
      {this.todoId, this.todoTitle, this.todoDesc, this.todoDT, this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(
      text: widget.todoTitle,
    );
    final descController = TextEditingController(
      text: widget.todoDesc,
    );
    String appTitle;

    if (widget.update == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Add Task";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add/Update Task',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 100,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _fromKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Note Title',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter some Text';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        minLines: 5,
                        controller: descController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write notes here',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter some Text';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Material(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (_fromKey.currentState!.validate()) {
                            if (widget.update == true) {
                              dbHelper!.update(
                                TodoModel(
                                  id: widget.todoId,
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: widget.todoDT,
                                ),
                              );
                            } else {
                              dbHelper!.insert(
                                TodoModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  dateandtime: DateFormat(
                                    'yMd',
                                  )
                                      .add_jm()
                                      .format(
                                        DateTime.now(),
                                      )
                                      .toString(),
                                ),
                              );
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                            titleController.clear();
                            descController.clear();
                            // TO CHECK WORKING OR NOT
                            print("Data added.");
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black,
                              //   blurRadius: 5,
                              //   spreadRadius: 1,
                              // ),
                            ],
                          ),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(
                            () {
                              titleController.clear();
                              descController.clear();
                            },
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 55,
                          width: 120,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black,
                              //   blurRadius: 5,
                              //   spreadRadius: 1,
                              // ),
                            ],
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
