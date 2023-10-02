import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:locker_app/flutter_flow/flutter_flow_util.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../backend/backend.dart';
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
  bool isLoading = false;
  List<String> emails = [];

  @override
  void initState() {
    fetchEmails();
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  void fetchEmails() async {
    setState(() {
      isLoading = true;
    });
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shared_with_me')
          .where('users email', isEqualTo: currentUserEmail)
          .get();

      for (final doc in querySnapshot.docs) {
        final email = doc['nominee email'];
        emails.add(email);
      }
      log('Emails: $emails');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching emails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              top: true,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.00, 0.00),
                            child: Text(
                              'Shared with me',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('detail_data')
                            .whereIn('email', emails)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final documents = snapshot.data?.docs;
                          return GridView.builder(
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
                                      final userDocRef = FirebaseFirestore
                                          .instance
                                          .collection('users')
                                          .doc(currentUserUid);
                                      DocumentSnapshot userSnapshot =
                                          await userDocRef.get();

                                      if (userSnapshot.exists) {
                                        Map<String, dynamic> userData =
                                            userSnapshot.data()
                                                as Map<String, dynamic>;

                                        ConstanData.encryptionKey =
                                            userData['encryptionKey'];
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
                                      }
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
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: Container(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.4,
                                              child: BottomSheet1Widget(
                                                datRef:
                                                    documents?[listViewIndex]
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/locker_appicon.png',
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
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
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width /
                                                        3,
                                                child: Text(
                                                  "${documents?[listViewIndex]['display_title']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .titleMedium
                                                      .copyWith(
                                                          color: Colors.black),
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
