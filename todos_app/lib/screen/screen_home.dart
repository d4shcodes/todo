import 'dart:async';
import 'dart:convert';

import 'package:todos_app/constant/colors.dart';
import 'package:todos_app/screen/screen_profile.dart';
import 'package:todos_app/provider/user_provider.dart';
import 'package:todos_app/services/note_service.dart';
import 'package:todos_app/utils/size_config.dart';
import 'package:todos_app/utils/wrapper.dart';
import 'package:todos_app/widgets/appbar.dart';
import 'package:todos_app/constant/taxonomy.dart';
import 'package:todos_app/utils/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:todos_app/utils/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List notes = [];
  bool isLoading = false;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  late SharedPreferences preferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserData();
  }

  Future getUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      preferences = await SharedPreferences.getInstance();

      final id = preferences.getInt('id') ?? 0;

      if (!mounted) return;
      Provider.of<UserProvider>(context, listen: false).setUid(id);

      // Get Note
      await getNote(id);
    } catch (e) {
      print('Error fetching data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  addNote(title, desc) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
      ),
    );

    try {
      var data = {'title': title, 'description': desc};

      final res = await NoteService().addNote(preferences.getInt('id')!, data);

      if (!mounted) return;

      Navigator.pop(context);

      if (res.statusCode == 200) {
        titleController.clear();
        descController.clear();

        await getNote(preferences.getInt('id')!);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task added", style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error has occured", style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } catch (e) {
      // Any other error (network, unexpected)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}', style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  getNote(id) async {
    try {
      final res = await NoteService().getNote(id);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body); // Decode JSON into a List

        setState(() {
          notes = data;
        });
      }
    } catch (e) {
      // Any other error (network, unexpected)
      print("Error: $e");
    }
  }

  updateNote(noteId, status) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
      ),
    );

    try {
      final res = await NoteService().updateNote(noteId, status);

      if (!mounted) return;

      Navigator.pop(context);

      if (res.statusCode == 200) {
        await getNote(preferences.getInt('id')!);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task updated", style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("An error has occured", style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.red,
          ),
        );
      }
    } catch (e) {
      // Any other error (network, unexpected)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: ${e.toString()}', style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  deleteNote(id) async {
    try {
      final res = await NoteService().deleteNote(id);

      if (res.statusCode == 200) {
        await getNote(preferences.getInt('id')!);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Task deleted", style: AppTypography.labelMedium.copyWith(color: AppColors.white)),
            backgroundColor: AppColors.green,
          ),
        );
      }
    } catch (e) {
      // Any other error (network, unexpected)
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final pad = MediaQuery.of(context).size.width * 0.04;

    return CustomWrapper(
      child: Scaffold(
        appBar: appBar(context, 1),
        body: SafeArea(
          child: isLoading
              ? Center(
                  child: Transform.scale(scale: MediaQuery.of(context).size.width * 0.0018, child: CircularProgressIndicator()),
                )
              : RefreshIndicator(
                  onRefresh: getUserData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(pad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userDetails(context, isTablet),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                        Divider(),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('TODO\'S', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w900))],
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.02),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [BoxShadow(color: AppColors.gray, spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 2))],
                              ),
                              child: ExpansionTile(
                                leading: Icon(
                                  Icons.checklist,
                                  size: SizeConfig.getProportionalWidth(24),
                                  color: note['completed'] == true ? AppColors.primary : AppColors.red,
                                ),
                                title: Text(
                                  note['title'] ?? '-',
                                  style: AppTypography.bodySmall.copyWith(
                                    decoration: note['completed'] == true ? TextDecoration.lineThrough : TextDecoration.none,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_drop_down, size: SizeConfig.getProportionalWidth(24), color: AppColors.black),
                                // 🔑 remove the divider lines
                                collapsedShape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                                shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
                                childrenPadding: EdgeInsets.zero,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(pad),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(note['description'] ?? 'No description available', style: AppTypography.bodySmall),
                                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                          Wrap(
                                            children: [
                                              Text('Status: ', style: AppTypography.bodySmall),
                                              Text(
                                                "${(note['completed']) ? 'Completed' : 'Not complete'}",
                                                style: AppTypography.bodySmall.copyWith(color: (note['completed']) ? AppColors.green : AppColors.red),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                          Row(
                                            children: [
                                              Expanded(
                                                child: IconButton(
                                                  onPressed: () {
                                                    updateNote(note['id'], !note['completed']);
                                                  },
                                                  icon: Icon(
                                                    (note['completed'] == true) ? Icons.close : Icons.check,
                                                    size: SizeConfig.getProportionalWidth(24),
                                                    color: (note['completed'] == true) ? AppColors.red : AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                              Expanded(
                                                child: IconButton(
                                                  onPressed: () {
                                                    deleteNote(note['id']);
                                                  },
                                                  icon: Icon(Icons.delete, size: SizeConfig.getProportionalWidth(24), color: AppColors.red),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        bottomNavigationBar: ResponsiveBuilder(
          mobile: buildBottomNav(context: context, iconSize: 24, labelSize: 12, selectedIndex: 0),
          tablet: buildBottomNav(context: context, iconSize: 42, labelSize: 24, selectedIndex: 0),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "Add New To-Do",
                    style: AppTypography.titleMedium, // Set the desired font size here
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: "Title"),
                        style: AppTypography.labelSmall, // Set the desired font size here
                      ),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(labelText: "Description"),
                        style: AppTypography.labelSmall, // Set the desired font size here
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel", style: AppTypography.labelSmall),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final title = titleController.text;
                        final desc = descController.text;

                        if (title.isNotEmpty && desc.isNotEmpty) {
                          addNote(title, desc);

                          Navigator.pop(context);
                        }
                      },
                      child: Text("Save", style: AppTypography.labelSmall),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add, size: SizeConfig.getProportionalWidth(24)),
        ),
      ),
    );
  }

  Row userDetails(BuildContext context, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(uid: preferences.getInt('id') ?? 0)));
          },
          child: ClipOval(
            child: Image.asset('assets/images/kermit.jpeg', width: isTablet ? 135 : 60, height: isTablet ? 135 : 60, fit: BoxFit.fill),
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WELCOME BACK,',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w400, // or w700
                  color: AppColors.gray,
                ),
              ),
              SizedBox(
                child: Text(
                  preferences.getString('name').toString(),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
