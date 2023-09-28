import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:locker_app/utils/deriveEncryptionKey_function.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class UpdateDataWidget extends StatefulWidget {
  const UpdateDataWidget({
    Key? key,
    required this.dataRef,
  }) : super(key: key);
  final DocumentReference? dataRef;

  @override
  _UpdateDataWidgetState createState() => _UpdateDataWidgetState();
}

class _UpdateDataWidgetState extends State<UpdateDataWidget> {
  bool isDataFetched = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String? encryptionKey;
  String? deviceId;
  DetailDataRecord? detailData;
  bool? bindToDevice=false;

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  TextEditingController? textController;
  TextEditingController? textController1;
  TextEditingController? textController2;

  @override
  void initState() {
    super.initState();
    fetchAndStoreData();
    fetchDeviceId();
    fetchUserEncryptionKey();
    setState(() {
      isDataFetched = true;
    });
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
    deviceId =androidInfo.id;    
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textController?.dispose();
    textController1?.dispose();
    textController2?.dispose();
    super.dispose();
  }

  Future<void> fetchAndStoreData() async {
    try {
      final snapshot = await widget.dataRef!.get();
      if (snapshot.exists) {
        setState(() {
          detailData = DetailDataRecord.fromSnapshot(snapshot);
          bindToDevice = detailData?.dataDeviceBinding;
          textController = TextEditingController(text: detailData?.displayTitle);
          textController1 = TextEditingController(
              text: decryptOperation(
                  detailData!.dataTitle, ConstanData.encryptionKey));
          textController2 = TextEditingController(
              text: decryptOperation(
                  detailData!.dataDescription, ConstanData.encryptionKey));
        });
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
            'Update Data',
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
        body: SafeArea(
          top: true,
          child: isDataFetched
              ? Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 20.0, 8.0, 0.0),
                        child: TextFormField(
                          controller: textController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Title to Display',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 20.0, 8.0, 0.0),
                        child: TextFormField(
                          controller: textController1,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Secure information Title',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          validator: (value) {
                            return null;
                          },
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 20.0, 8.0, 0.0),
                        child: TextFormField(
                          controller: textController2,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Secure information Description',
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ),
                      Row(
                  children: [
                    Checkbox(
                      value: bindToDevice,
                      onChanged: (value) {
                        setState(() {
                          bindToDevice = value!;
                          log("value is : $bindToDevice");
                        });
                      },
                    ),
                    Text('Bind to this device'),
                  ],
                ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10.0, 20.0, 10.0, 0.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            log(" text is ${textController1!.text}");
                            if (formKey.currentState!.validate()) {
                              await widget.dataRef!.update(
                                createDetailDataRecordData(
                                  displayTitle: textController!.text,
                                  dataTitle: textController1!.text,
                                  dataDescription: textController2!.text,
                                  deviceBinding: bindToDevice,
                                  deviceDetail: encryptOperation(
                                            deviceId!,
                                            encryptionKey!)
                                ),
                              );
                              Navigator.of(context).pop();
                            }
                          },
                          text: 'Update',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Roboto Slab',
                                  color: Colors.white,
                                ),
                            elevation: 3.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
