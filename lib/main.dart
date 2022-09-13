import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data.dart';
import 'package:todo/date.dart';

const taskBoxName = 'tasks';

void main() async {
  // sakht va register shodn Hive
  await Hive.initFlutter();
  // register shodn AdapterTaskHive
  Hive.registerAdapter(TaskAdapter());
  // register shodn Adapter PriortyHive
  Hive.registerAdapter(PriorityAdapter());
  //baz shodn hive box va taghirat dar task ha.............
  await Hive.openBox(taskBoxName);

  /// taghir rang StatusBar App
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryContiner));

  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryContiner = Color(0xff5c0aff);
const Color secondrTextColor = Color(0xffafbed0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Color primaryTextColor = const Color(0xff1d2830);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            labelStyle: TextStyle(color: secondrTextColor),
            iconColor: secondrTextColor,
          ),
          //them dadn be text ha
          textTheme: GoogleFonts.poppinsTextTheme(
            const TextTheme(
              headline6: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          colorScheme: ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryContiner,
            background: const Color(0xfff3f5f8),
            onBackground: primaryTextColor,
            onSurface: primaryTextColor,
            // this is Color for floatActionButton
            secondary: primaryColor,
            // this is Color for Text FloatAction button
            onSecondary: Colors.white,
            onPrimary: secondrTextColor,
          )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /// sakht box va rikhtan an dar motghayer box
    final box = Hive.box(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditTaskScreen(task: TaskEntity(),)));
          },
          label: Row(
            children: [
              const Text('Add new Task'),
              const SizedBox(
                width: 6,
              ),
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 142, 90, 247),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                  size: 24,
                ),
              )
            ],
          )),

      /// buldier ha bad pop shodn avaz mishn
      body: SafeArea(
        child: Column(
          children: [
            //sakht Appbar applictions
            Container(
              height: 110,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                themeData.colorScheme.primary,
                themeData.colorScheme.primaryContainer,
              ])),
              child: Column(
                children: [
                  //nmayesh nam app va Iocn App
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'toDoList',
                          style: themeData.textTheme.headline6,
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: themeData.colorScheme.onSecondary,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  //sakht Search box app
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 38,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(19),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                            )
                          ]),
                      child: const TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search),
                            label: Text('Search for task,,,')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                // ==============================================>>>>>>>>>>>>>>>> be chi mikhy gosh bdi ta taghit kni
                valueListenable: box.listenable(),
                builder: (context, box, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),

                    /// be eza  value<mghadir> dakhel box ya dataBase
                    itemCount: box.values.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Today',
                                  style: themeData.textTheme.headline6!
                                      .copyWith(
                                          color: Colors.black, fontSize: 18),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 60,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(3)),
                                )
                              ],
                            ),
                            MaterialButton(
                                elevation: 0,
                                textColor: secondrTextColor,
                                color: const Color(0xffeaeff5),
                                onPressed: () {},
                                child: Row(
                                  children: const [
                                    Text('Deleted All'),
                                    SizedBox(width: 4),
                                    Icon(
                                      CupertinoIcons.delete_solid,
                                      size: 18,
                                    )
                                  ],
                                ))
                          ],
                        );
                      } else {
                        /// chon Values Iterable bod bayd az to list estfade konim
                        final TaskEntity task = box.values.toList()[index - 1];
                        return TaskItem(task: task);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// sakht safhe EditTask jajaht Ezafe krdn Task ha be app


/// item haye marbot be task
class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        //======================================================================>>>>>>>>>>>>>>>>>>>>>vaghti vaziat State avaz shod
        setState(() {
          widget.task.isComplet = !widget.task.isComplet;
        });
      },
      child: Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.only(right: 16, left: 16),
          height: 84,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: themeData.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  color: Colors.black.withOpacity(0.1),
                )
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //====================================================================>>>>>>>>>>>>>>>>>>cheack box custom
              MycheackBox(value: widget.task.isComplet),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.task.name,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 22,
                    decoration: widget.task.isComplet
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

/// Craet Custom Cheack box for tasks
class MycheackBox extends StatelessWidget {
  final bool value;
  const MycheackBox({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: !value ? Border.all(color: secondrTextColor, width: 2) : null,
          color: value ? primaryColor : null),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 15,
            )
          : null,
    );
  }
}