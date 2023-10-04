import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/pages/add_nominee/add_nominee_model.dart';
import 'package:locker_app/pages/add_nominee/widgets/add_nominee_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class AddNomineeWidget extends StatefulWidget {
  @override
  _AddNomineeWidgetState createState() => _AddNomineeWidgetState();
}

class _AddNomineeWidgetState extends State<AddNomineeWidget> {
  late AddNomineeModel _model;
  String? encryptionKey;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddNomineeModel());
    fetchUserEncryptionKey();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void fetchUserEncryptionKey() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        encryptionKey = userData['encryption key'];        
      } else {
        log('User not found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // encryptionKey = sharedPreferences.getString('usersEncreptionKey');
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddNomineePageDialog(
                    confirmBtnText: 'Add Nominee',
                    btnClickOperation: 1,
                    param: encryptionKey,
                  );
                },
              );
            },
            backgroundColor: FlutterFlowTheme.of(context).primary,
            icon: Icon(
              Icons.add,
            ),
            elevation: 8.0,
            label: Text(
              'Add Nominee',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto Slab',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
            ),
          ),
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.arrow_back,
                color: Color(0xFFFC951C),
                size: 30.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
            title: Text(
              'Add Nominee',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    color: Color(0xFFFC951C),
                    fontSize: 22.0,
                  ),
            ),
            actions: [],
            centerTitle: false,
            elevation: 2.0,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shared_with_me')
                .where('users email', isEqualTo: currentUserEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final documents = snapshot.data?.docs;

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: documents?.length,
                itemBuilder: (context, index) {
                  final email = documents?[index]['nominee email'] ?? '';

                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: FlutterFlowTheme.of(context).primary,
                            size: MediaQuery.sizeOf(context).height*0.15,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            email,
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Roboto Slab',
                                      color: Colors.black,
                                    ),
                          )
                        ],
                      ),
                    ),
                  );
                }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.9),
              );
            },
          )),
    );
  }
}
