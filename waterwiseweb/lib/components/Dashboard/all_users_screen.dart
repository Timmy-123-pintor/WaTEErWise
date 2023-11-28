// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waterwiseweb/Screens/services/firebase_auth_methods.dart';
import 'package:waterwiseweb/Screens/userInfo/userDetails.dart';
import 'package:waterwiseweb/Screens/widgets/edit_user_form.dart';
import 'package:waterwiseweb/components/Registration/user_registration.dart';
import 'package:waterwiseweb/constants/cons.dart';
import 'package:waterwiseweb/models/user_model.dart';

class Table02UserListWidget extends StatefulWidget {
  const Table02UserListWidget({Key? key}) : super(key: key);

  @override
  _Table02UserListWidgetState createState() => _Table02UserListWidgetState();
}

class _Table02UserListWidgetState extends State<Table02UserListWidget> {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  late Future<List<UserModel>> futureUsers;
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  final FirebaseAuthMethods _authMethods =
      FirebaseAuthMethods(FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    futureUsers = _authMethods.fetchAllUsers();

    // Get initial list of users and assign to both futureUsers and filteredUsers
    futureUsers.then((users) {
      setState(() {
        allUsers = users;
        filteredUsers = users;
      });
    });

    // Listener for the search field
    textController!.addListener(() {
      filterUsers();
    });
  }

  // Filter users based on search input
  void filterUsers() {
    String searchTerm = textController!.text.toLowerCase();
    setState(() {
      filteredUsers = allUsers
          .where((user) => user.fullName.toLowerCase().contains(searchTerm))
          .toList();
    });
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

  DataColumn buildDataColumn(String label) {
    return DataColumn(
      label: Center(
        child: Text(
          label,
          style: GoogleFonts.quicksand(
            textStyle: information,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 1170,
          ),
          decoration: BoxDecoration(
            color: tWhite,
            boxShadow: const [
              BoxShadow(
                blurRadius: 3,
                color: Color(0x33000000),
                offset: Offset(0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: tGray,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 12, 0),
                            child: Text(
                              'My Users',
                              style: GoogleFonts.quicksand(
                                textStyle: desc2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 4, 12, 0),
                            child: Text(
                              'Below is the list of users, select them for details.',
                              style: GoogleFonts.quicksand(
                                textStyle: subDescG,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Responsive visibility handled by MediaQuery or custom logic
                    if (MediaQuery.of(context).size.width >=
                        600) // Example breakpoint
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
                        child: SizedBox(
                          width: 270,
                          child: TextFormField(
                            controller: textController,
                            focusNode: textFieldFocusNode,
                            textCapitalization: TextCapitalization.sentences,
                            obscureText: false,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Search users...',
                              hintStyle: theme.textTheme.bodyMedium,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: tGray,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: tBlue,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: theme.hintColor,
                                size: 20,
                              ),
                            ),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Quicksand',
                            ),
                            // You will need to implement your own validation logic
                            // validator: (value) => myValidatorFunction(value),
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // Assuming UserRegistration is the widget that contains your form
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const AddUser(), // Your custom form widget
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: tWhite,
                        backgroundColor: tBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        fixedSize: const Size(170.0, 40.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_rounded,
                            size: 25,
                          ),
                          const SizedBox(
                              width: 8), // Spacing between icon and text
                          Text(
                            'Create User',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontFamily: 'Quicksand',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft:
                          Radius.circular(10.0), // Adjust the radius as needed
                      topRight:
                          Radius.circular(10.0), // Adjust the radius as needed
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        headingRowHeight: 45.0,
                        headingRowColor:
                            MaterialStateColor.resolveWith((states) => tNavBar),
                        columns: [
                          buildDataColumn('Role'),
                          buildDataColumn('User Information'),
                          buildDataColumn('Location'),
                          buildDataColumn('Device Type'),
                          buildDataColumn('Device Name'),
                          buildDataColumn('Actions'),
                        ],
                        rows: filteredUsers.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const UserDetails(),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        user.role,
                                        style: GoogleFonts.quicksand(
                                          textStyle: name,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      user.fullName,
                                      style: GoogleFonts.quicksand(
                                        textStyle: name,
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: GoogleFonts.quicksand(
                                        textStyle: email,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      user.location.isEmpty
                                          ? 'No location'
                                          : user.location,
                                      style: GoogleFonts.quicksand(
                                        textStyle: userIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      user.deviceType.isEmpty
                                          ? 'No device type'
                                          : user.deviceType,
                                      style: GoogleFonts.quicksand(
                                        textStyle: userIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      user.deviceName.isEmpty
                                          ? 'No device name'
                                          : user.deviceName,
                                      style: GoogleFonts.quicksand(
                                        textStyle: userIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: tGray,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: EditUserForm(user: user),
                                            );
                                          },
                                        ).then((_) {
                                          setState(() {
                                            futureUsers =
                                                _authMethods.fetchAllUsers();
                                          });
                                        });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: tRed,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return AlertDialog(
                                              title: const Text('Delete User'),
                                              content: const Text(
                                                  'Are you sure you want to delete this user?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(dialogContext)
                                                        .pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Delete'),
                                                  onPressed: () async {
                                                    Navigator.of(dialogContext)
                                                        .pop();
                                                    await _authMethods
                                                        .deleteUser(
                                                            user.uid, context);
                                                    futureUsers = _authMethods
                                                        .fetchAllUsers();
                                                    futureUsers.then((users) {
                                                      setState(() {
                                                        allUsers = users;
                                                        filteredUsers = allUsers
                                                            .where((user) => user
                                                                .fullName
                                                                .toLowerCase()
                                                                .contains(
                                                                    textController!
                                                                        .text
                                                                        .toLowerCase()))
                                                            .toList();
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Builder(
                //     builder: (context) {
                //       // Check if the filteredUsers list is empty
                //       if (filteredUsers.isEmpty) {
                //         if (textController!.text.isEmpty) {
                //           // If the search field is empty, that means the users are still being fetched
                //           // or there are no users at all. Show a loading indicator or a 'no users' message accordingly.
                //           return const Center(
                //               child: CircularProgressIndicator());
                //         } else {
                //           // If the search field is not empty but no users match the search, show a 'No users found' message
                //           return const Center(child: Text('No users found.'));
                //         }
                //       }

                //       return ListView.builder(
                //         itemCount: filteredUsers.length,
                //         itemBuilder: (context, index) {
                //           var user = filteredUsers[index];
                //           return Container(
                //             decoration: const BoxDecoration(
                //               border: Border(
                //                 bottom: BorderSide(
                //                   color: tGray,
                //                   width: 1.0,
                //                 ),
                //               ),
                //             ),
                //             child: ListTile(
                //               // title: Text(user.fullName),
                //               title: Row(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       const SizedBox(
                //                         height: 15,
                //                       ),
                //                       Text(user.role),
                //                     ],
                //                   ),
                //                   const Spacer(),
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       const SizedBox(
                //                         height: 15,
                //                       ),
                //                       Text(user.fullName),
                //                       Text(user.email),
                //                     ],
                //                   ),
                //                   const Spacer(),
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(user.location.isEmpty
                //                           ? 'No location'
                //                           : user.location),
                //                     ],
                //                   ),
                //                   const Spacer(),
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(user.deviceType.isEmpty
                //                           ? 'No device type'
                //                           : user.deviceType),
                //                     ],
                //                   ),
                //                   const Spacer(),
                //                   Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       Text(user.deviceName.isEmpty
                //                           ? 'No device name'
                //                           : user.deviceName),
                //                     ],
                //                   ),
                //                   const Spacer(),
                //                   IconButton(
                //                     icon: const Icon(Icons.edit),
                //                     onPressed: () {
                //                       showDialog(
                //                         context: context,
                //                         builder: (BuildContext dialogContext) {
                //                           // Return the EditUserForm as a dialog
                //                           return Dialog(
                //                             shape: RoundedRectangleBorder(
                //                               borderRadius:
                //                                   BorderRadius.circular(16),
                //                             ),
                //                             child: EditUserForm(
                //                                 user: filteredUsers[
                //                                     index]), // Pass the selected user to the form
                //                           );
                //                         },
                //                       ).then((_) {
                //                         // Optional: If you want to refresh the user list after editing a user
                //                         // setState to trigger a rebuild of the FutureBuilder
                //                         setState(() {
                //                           futureUsers = _authMethods
                //                               .fetchAllUsers(); // Refresh the user list
                //                         });
                //                       });
                //                     },
                //                   ),
                //                   IconButton(
                //                     icon: const Icon(Icons.delete),
                //                     onPressed: () {
                //                       showDialog(
                //                         context: context,
                //                         builder: (BuildContext dialogContext) {
                //                           return AlertDialog(
                //                             title: const Text('Delete User'),
                //                             content: const Text(
                //                                 'Are you sure you want to delete this user?'),
                //                             actions: <Widget>[
                //                               TextButton(
                //                                 child: const Text('Cancel'),
                //                                 onPressed: () {
                //                                   Navigator.of(dialogContext)
                //                                       .pop(); // Dismiss the dialog but don't delete
                //                                 },
                //                               ),
                //                               TextButton(
                //                                 child: const Text('Delete'),
                //                                 onPressed: () async {
                //                                   Navigator.of(dialogContext)
                //                                       .pop(); // Dismiss the dialog and proceed to delete
                //                                   // Call the delete method from FirebaseAuthMethods
                //                                   await _authMethods.deleteUser(
                //                                       filteredUsers[index].uid,
                //                                       context);
                //                                   // Refresh the list after deleting
                //                                   futureUsers = _authMethods
                //                                       .fetchAllUsers();
                //                                   futureUsers.then((users) {
                //                                     setState(() {
                //                                       allUsers = users;
                //                                       filteredUsers = allUsers
                //                                           .where((user) => user
                //                                               .fullName
                //                                               .toLowerCase()
                //                                               .contains(
                //                                                   textController!
                //                                                       .text
                //                                                       .toLowerCase()))
                //                                           .toList();
                //                                     });
                //                                   });
                //                                 },
                //                               ),
                //                             ],
                //                           );
                //                         },
                //                       );
                //                     },
                //                   ),
                //                 ],
                //               ),
                //               // trailing: Row(
                //               //   mainAxisSize: MainAxisSize.min,
                //               //   children: <Widget>[
                //               //     IconButton(
                //               //       icon: const Icon(Icons.edit),
                //               //       onPressed: () {
                //               //         showDialog(
                //               //           context: context,
                //               //           builder: (BuildContext dialogContext) {
                //               //             // Return the EditUserForm as a dialog
                //               //             return Dialog(
                //               //               shape: RoundedRectangleBorder(
                //               //                 borderRadius:
                //               //                     BorderRadius.circular(16),
                //               //               ),
                //               //               child: EditUserForm(
                //               //                   user: filteredUsers[
                //               //                       index]), // Pass the selected user to the form
                //               //             );
                //               //           },
                //               //         ).then((_) {
                //               //           // Optional: If you want to refresh the user list after editing a user
                //               //           // setState to trigger a rebuild of the FutureBuilder
                //               //           setState(() {
                //               //             futureUsers = _authMethods
                //               //                 .fetchAllUsers(); // Refresh the user list
                //               //           });
                //               //         });
                //               //       },
                //               //     ),
                //               //     IconButton(
                //               //       icon: const Icon(Icons.delete),
                //               //       onPressed: () {
                //               //         showDialog(
                //               //           context: context,
                //               //           builder: (BuildContext dialogContext) {
                //               //             return AlertDialog(
                //               //               title: const Text('Delete User'),
                //               //               content: const Text(
                //               //                   'Are you sure you want to delete this user?'),
                //               //               actions: <Widget>[
                //               //                 TextButton(
                //               //                   child: const Text('Cancel'),
                //               //                   onPressed: () {
                //               //                     Navigator.of(dialogContext)
                //               //                         .pop(); // Dismiss the dialog but don't delete
                //               //                   },
                //               //                 ),
                //               //                 TextButton(
                //               //                   child: const Text('Delete'),
                //               //                   onPressed: () async {
                //               //                     Navigator.of(dialogContext)
                //               //                         .pop(); // Dismiss the dialog and proceed to delete
                //               //                     // Call the delete method from FirebaseAuthMethods
                //               //                     await _authMethods.deleteUser(
                //               //                         filteredUsers[index].uid,
                //               //                         context);
                //               //                     // Refresh the list after deleting
                //               //                     futureUsers = _authMethods
                //               //                         .fetchAllUsers();
                //               //                     futureUsers.then((users) {
                //               //                       setState(() {
                //               //                         allUsers = users;
                //               //                         filteredUsers = allUsers
                //               //                             .where((user) => user
                //               //                                 .fullName
                //               //                                 .toLowerCase()
                //               //                                 .contains(
                //               //                                     textController!
                //               //                                         .text
                //               //                                         .toLowerCase()))
                //               //                             .toList();
                //               //                       });
                //               //                     });
                //               //                   },
                //               //                 ),
                //               //               ],
                //               //             );
                //               //           },
                //               //         );
                //               //       },
                //               //     ),
                //               //   ],
                //               // ),
                //             ),
                //           );
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
