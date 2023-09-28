import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locker_app/pages/veryfication_page/verification_page_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../utils/deriveEncryptionKey_function.dart';
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
  bool? auth_password_bool;
  String? encryptedPassword;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchUserEncryptionKey();
    fetchUserLocalData();
    _model = createModel(context, () => VerificationScreenModel());
  }

  void fetchUserLocalData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    auth_password_bool = sharedPreferences.getBool('auth_password_bool');
    if (auth_password_bool == true) {
      encryptedPassword = sharedPreferences.getString('user_auth_password');
    }
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
                alignment: AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      if (auth_password_bool == true) {
                        String pin = encryptOperation(
                            _model.pinCodeController.text, encryptionKey!);

                        if (pin == encryptedPassword!) {
                          context.pushNamed(
                            'homePage',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: false,
                                transitionType: PageTransitionType.rightToLeft,
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
                        }
                      } else {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        String pin = encryptOperation(
                            _model.pinCodeController.text, encryptionKey!);
                        sharedPreferences.setBool('auth_password_bool', true);
                        sharedPreferences.setString('user_auth_password', pin);
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
}
