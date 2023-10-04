import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locker_app/flutter_flow/flutter_flow_util.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../utils/deriveEncryptionKey_function.dart';
import '../bottom_sheet1/bottom_sheet1_widget.dart';
import '../dialogue/custom_dialogue.dart';

class SharedWithMe extends StatefulWidget {
  const SharedWithMe({super.key});

  @override
  State<SharedWithMe> createState() => _SharedWithMeState();
}

class _SharedWithMeState extends State<SharedWithMe> {
  bool? isLoading = true;
  String? encryptionKey;
  List<String> emails = [];
  List<DocumentSnapshot>? documents = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    fetchData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      fetchUserEncryptionKey();
      log('$isLoading');
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  void fetchDocuments() async {
    try {
      setState(() {
        isLoading = true;
      });
      // Fetch documents
      final querySnapshot = await FirebaseFirestore.instance
          .collection('detail_data')
          .whereIn('email', emails)
          .get();

      setState(() {
        documents = querySnapshot.docs;
      });
      setState(() {
        isLoading = false;
      });
      log('$isLoading');
    } catch (e) {
      log('Error fetching documents: $e');
    }
  }

  void fetchUserEncryptionKey() async {
    try {
      setState(() {
        isLoading = true;
      });
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUserEmail)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        encryptionKey = userData['encryption key'];
        fetchEmails();
        log('$isLoading');
      } else {
        log('User not found');
      }
    } catch (e) {
      log('Error fetching user data: $e');
    }

    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // encryptionKey = sharedPreferences.getString('usersEncreptionKey');
  }

  void fetchEmails() async {
    try {
      setState(() {
        isLoading = true;
      });
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shared_with_me')
          .where('nominee email', isEqualTo: currentUserEmail)
          .get();

      for (final doc in querySnapshot.docs) {
        final email = doc['users email'];
        emails.add(email);
      }
      log('$isLoading');

      fetchDocuments();
    } catch (e) {
      log('Error fetching emails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            color: FlutterFlowTheme.of(context).primary,
            size: 30.0,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Shared with me',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Outfit',
                color: FlutterFlowTheme.of(context).primary,
                fontSize: 22.0,
              ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 2.0,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: isLoading == true
              ? Center(
                  child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                ))
              : SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.9, crossAxisCount: 2),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: documents?.length,
                          itemBuilder: (context, listViewIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  try {
                                    ConstanData.encryptionKey = encryptionKey!;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          confirmBtnText: 'Submit',
                                          btnClickOperation: 4,
                                          param: documents?[listViewIndex]
                                              .reference,
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    print('Error fetching user email: $e');
                                  }
                                },
                                onLongPress: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor:
                                        FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                    barrierColor: Color(0x00FF0000),
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) {
                                      return GestureDetector(
                                        child: Padding(
                                          padding:
                                              MediaQuery.viewInsetsOf(context),
                                          child: Container(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.4,
                                            child: BottomSheet1Widget(
                                              datRef: documents?[listViewIndex]
                                                  .reference,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ).then((value) => safeSetState(() {}));
                                },
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/locker_appicon.png',
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.17,
                                        fit: BoxFit.contain,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width /
                                                  3,
                                              child: Text(
                                                "${documents?[listViewIndex]['display_title']}",
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .titleMedium
                                                        .copyWith(
                                                            color:
                                                                Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).animate().slideX(),
                              ),
                            );
                          },
                        )),
                  ],
                ),
        ),
      ),
    );
  }
}
