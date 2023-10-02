import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../utils/deriveEncryptionKey_function.dart';
import '../dialogue/custom_dialogue.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/bottom_sheet1/bottom_sheet1_widget.dart';
import '/pages/dialogue/dialogue_widget.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  late String decryptionKey;
  String? deviceId;
  String? encryptionKey;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchUserEncryptionKey();
    _model = createModel(context, () => HomePageModel());
    fetchDeviceId();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  void fetchUserEncryptionKey() async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        encryptionKey = userData['encryptionKey'];
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  fetchDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  }

  void fetchUserEmail() async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserUid);
      DocumentSnapshot userSnapshot = await userDocRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        decryptionKey = userData['encryptionKey'];
      }
    } catch (e) {
      print('Error fetching user email: $e');
    }
  }

  Future<void> clearAllSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
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
            context.pushNamed(
              'add_docs',
              extra: <String, dynamic>{
                kTransitionInfoKey: TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.leftToRight,
                ),
              },
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          icon: Icon(
            Icons.add,
          ),
          elevation: 8.0,
          label: Text(
            'Add Data',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Roboto Slab',
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
          ),
        ),
        drawer: Container(
          width: MediaQuery.sizeOf(context).width * 0.7,
          child: Drawer(
            elevation: 16.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * .25,
                  decoration: BoxDecoration(
                    color: Color(0xFFFC951C),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10.0,
                        MediaQuery.sizeOf(context).height * .05, 10.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.account_circle,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: MediaQuery.sizeOf(context).height * .12),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 5.0, 0.0, 0.0),
                          child: Text(
                            currentUserEmail,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Roboto Slab',
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      'add_nominee',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.leftToRight,
                        ),
                      },
                    );
                  },
                  leading: Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Add Nominee',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Roboto Slab',
                          color: Colors.black,
                        ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    context.pop();
                    context.pushNamed(
                      'shared_with_me',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.leftToRight,
                        ),
                      },
                    );
                  },
                  leading: Icon(
                    Icons.people,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Shared with me',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Roboto Slab',
                          color: Colors.black,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 15),
                  child: FFButtonWidget(
                    onPressed: () async {
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      clearAllSharedPreferences();
                      GoRouter.of(context).clearRedirectLocation();
                      context.goNamedAuth('sign_in', context.mounted);
                    },
                    text: 'Logout',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Roboto Slab',
                                color: Colors.white,
                              ),
                      elevation: 3,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 0.0, 10.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            scaffoldKey.currentState!.openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.00, 0.00),
                        child: Text(
                          'Home Page',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: 'Outfit',
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: StreamBuilder<List<DetailDataRecord>>(
                    stream: queryDetailDataRecord(
                        queryBuilder: (detailDataRecord) => detailDataRecord
                            .where('user_id', isEqualTo: currentUserUid)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height / 1.2,
                          child: Center(
                            child: Text("No Data"),
                          ),
                        );
                      }
                      List<DetailDataRecord> allData = snapshot.data!;
                      List<DetailDataRecord> filteredData =
                          allData.where((data) {
                        return data.dataDeviceBinding == false ||
                            (data.dataDeviceBinding == true &&
                                data.deviceDetail ==
                                    encryptOperation(
                                        deviceId!, encryptionKey!));
                      }).toList();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.9, crossAxisCount: 2),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (context, listViewIndex) {
                          final listViewDetailDataRecord =
                              filteredData[listViewIndex];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                try {
                                  final userDocRef = FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUserUid);
                                  DocumentSnapshot userSnapshot =
                                      await userDocRef.get();

                                  if (userSnapshot.exists) {
                                    Map<String, dynamic> userData = userSnapshot
                                        .data() as Map<String, dynamic>;

                                    ConstanData.encryptionKey =
                                        userData['encryptionKey'];
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                          confirmBtnText: 'Submit',
                                          btnClickOperation: 1,
                                          param: listViewDetailDataRecord
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
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  barrierColor: Color(0x00FF0000),
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () => FocusScope.of(context)
                                          .requestFocus(_model.unfocusNode),
                                      child: Padding(
                                        padding:
                                            MediaQuery.viewInsetsOf(context),
                                        child: Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.4,
                                          child: BottomSheet1Widget(
                                            datRef: listViewDetailDataRecord
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                              listViewDetailDataRecord
                                                  .displayTitle,
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .copyWith(
                                                          color: Colors.black),
                                            ),
                                          ),
                                          Builder(
                                            builder: (context) => InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showAlignedDialog(
                                                  barrierColor:
                                                      Color(0x00FF0000),
                                                  context: context,
                                                  isGlobal: true,
                                                  avoidOverflow: false,
                                                  targetAnchor:
                                                      AlignmentDirectional(
                                                              0.0, 0.0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  followerAnchor:
                                                      AlignmentDirectional(
                                                              0.0, 0.0)
                                                          .resolve(
                                                              Directionality.of(
                                                                  context)),
                                                  builder: (dialogContext) {
                                                    return Material(
                                                      color: Colors.transparent,
                                                      child: GestureDetector(
                                                        onTap: () => FocusScope
                                                                .of(context)
                                                            .requestFocus(_model
                                                                .unfocusNode),
                                                        child: DialogueWidget(
                                                          dataRef:
                                                              listViewDetailDataRecord
                                                                  .reference,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then(
                                                    (value) => setState(() {}));
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0xFFFF0000),
                                                size: 24.0,
                                              ),
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
      ),
    );
  }
}
