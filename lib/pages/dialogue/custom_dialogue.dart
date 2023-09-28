import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:locker_app/auth/firebase_auth/auth_util.dart';
import 'package:locker_app/backend/backend.dart';
import 'package:locker_app/pages/dialogue/custom_dialogue_model.dart';

import '../../flutter_flow/flutter_flow_model.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/nav/serialization_util.dart';
import '../../utils/deriveEncryptionKey_function.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({Key? key, required this.param});
  final dynamic param;
  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late CustomDialogueModel customDialogueModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    customDialogueModel = createModel(context, () => CustomDialogueModel());
    customDialogueModel.passwordFieldController ??= TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    customDialogueModel.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Verify authenticity'),
      content: Form(
        key: customDialogueModel.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            TextFormField(
              controller: customDialogueModel.passwordFieldController,
              decoration: InputDecoration(
                labelText: 'Master Password',
                labelStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto Slab',
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 16.0,
                      lineHeight: 1.5,
                    ),
                hintText: 'Enter Master Password',
                hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Roboto Slab',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 16.0,
                      lineHeight: 1.5,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFD0D5DD),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF0000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFF0000),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsetsDirectional.fromSTEB(14.0, 10.0, 14.0, 10.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Roboto Slab',
                    color: FlutterFlowTheme.of(context).primaryText,
                    fontSize: 16.0,
                    lineHeight: 1.5,
                  ),
              validator: customDialogueModel.passwordFieldControllerValidator
                  .asValidator(context),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFFF0000))),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Close',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                      color: Color(0xFFFF0000),
                    ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () async {
              if (customDialogueModel.formKey.currentState!.validate()) {
                String enteredText =
                    customDialogueModel.passwordFieldController!.text;

                final encryptionKey = await deriveEncryptionKey(
                    enteredText, currentUserUid, currentUserEmail);

                if (bytesToHexString(encryptionKey) ==
                    ConstanData.encryptionKey) {
                  context.pushNamed(
                    'update_data',
                    queryParameters: {
                      'dataRef': serializeParam(
                        widget.param,
                        ParamType.DocumentReference,
                      ),
                    }.withoutNulls,
                  );
                  Navigator.of(context).pop();
                } else {
                  customDialogueModel.passwordFieldController!.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please Enter Correct Master Password',
                        style: TextStyle(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                      ),
                      duration: Duration(milliseconds: 4000),
                      backgroundColor: FlutterFlowTheme.of(context).error,
                    ),
                  );
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xFFFC951C),
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Submit',
                style: FlutterFlowTheme.of(context).bodyMedium.copyWith(
                    color: FlutterFlowTheme.of(context).primaryBackground),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
