import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/pages/veryfication_page/verification_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../utils/deriveEncryptionKey_function.dart';
import '../dialogue/custom_dialogue.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreenWidget extends StatefulWidget {
  const VerificationScreenWidget({Key? key}) : super(key: key);

  @override
  _VerificationScreenWidgetState createState() =>
      _VerificationScreenWidgetState();
}

class _VerificationScreenWidgetState extends State<VerificationScreenWidget> {
  late VerificationScreenModel _model;
  String? encryptionKey;
  bool? authPasswordBool;
  String? encryptedPassword;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ConstanData.userId=currentUserUid;
    fetchUserEncryptionKey();
    _model = createModel(context, () => VerificationScreenModel());
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
        body: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 88, 0, 0),
                  child: Text(
                    'Enter your User Authentication Password',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Roboto Slab',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyLargeFamily),
                        ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Text(
                    'Enter Veryfication password for Locker App Access.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Roboto Slab',
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 22, 0, 0),
                  child: PinCodeTextField(
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 6,
                    textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Roboto Slab',
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyLargeFamily),
                        ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    enableActiveFill: false,
                    autoFocus: true,
                    enablePinAutofill: false,
                    errorTextSpace: 16,
                    showCursor: true,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    obscureText: true,
                    obscuringCharacter: '*',
                    hintCharacter: '-',
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      fieldHeight: 44,
                      fieldWidth: 44,
                      borderWidth: 1,
                      borderRadius: BorderRadius.circular(12),
                      shape: PinCodeFieldShape.box,
                      activeColor: FlutterFlowTheme.of(context).primary,
                      inactiveColor: FlutterFlowTheme.of(context).secondaryText,
                      selectedColor: FlutterFlowTheme.of(context).primary,
                      activeFillColor: FlutterFlowTheme.of(context).primary,
                      inactiveFillColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      selectedFillColor: FlutterFlowTheme.of(context).primary,
                    ),
                    controller: _model.pinCodeController,
                    onChanged: (_) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator:
                        _model.pinCodeControllerValidator.asValidator(context),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 5, 16, 05),
                  child: SelectionArea(
                      child: GestureDetector(
                    onTap: () async {
                      try {
                        final userDocRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUserUid);
                        DocumentSnapshot userSnapshot = await userDocRef.get();

                        if (userSnapshot.exists) {
                          Map<String, dynamic> userData =
                              userSnapshot.data() as Map<String, dynamic>;

                          ConstanData.encryptionKey = userData['encryptionKey'];
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomDialog(
                              confirmBtnText: 'Verify',
                              btnClickOperation: 3,
                            );
                          },
                        ).then((value) {
                          log("value is $value");
                          fetchUserEncryptionKey();
                        });
                        initState();
                      } catch (e) {
                        print('Error fetching user email: $e');
                      }
                    },
                    child: Text(
                      'reset authentication password?',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Roboto Slab',
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  )),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      final enteredPin = _model.pinCodeController.text;
                      log("Entered Pin: ${enteredPin.length}");
                      if (enteredPin.length == 6) {
                        if (authPasswordBool == true) {
                          String pin =
                              encryptOperation(enteredPin, encryptionKey!);

                          if (pin == encryptedPassword!) {
                            context.pushNamed(
                              'homePage',
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: false,
                                  transitionType:
                                      PageTransitionType.rightToLeft,
                                ),
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please Enter Correct Authentication Password',
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                                duration: Duration(milliseconds: 4000),
                                backgroundColor:
                                    FlutterFlowTheme.of(context).error,
                              ),
                            );
                            _model.pinCodeController?.clear();
                          }
                        } else {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          String pin = encryptOperation(
                              _model.pinCodeController.text, encryptionKey!);
                          sharedPreferences.setBool('auth_password_bool', true);
                          sharedPreferences.setString(
                              'user_auth_password', pin);
                          context.pushNamed(
                            'homePage',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: false,
                                transitionType: PageTransitionType.rightToLeft,
                              ),
                            },
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please Enter a Valid 6-digit PIN',
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                              ),
                            ),
                            duration: Duration(milliseconds: 4000),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    },
                    text: 'Submit',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width,
                      height: 42,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: FlutterFlowTheme.of(context)
                          .titleSmall
                          .override(
                            fontFamily: 'Roboto Slab',
                            color: Colors.white,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).titleSmallFamily),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isPinValid(String pin) {
    if (pin.length == 6) {
      return true;
    } else {
      return false;
    }
  }
}
