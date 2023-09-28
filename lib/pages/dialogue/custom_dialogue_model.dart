import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CustomDialogueModel extends FlutterFlowModel {

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  // State field(s) for PasswordField widget.
  TextEditingController? passwordFieldController;
  late bool passwordFieldVisibility;
  String? Function(BuildContext, String?)? passwordFieldControllerValidator;
  String? _passwordFieldControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 12) {
      return 'Master Password is at least 12 character Long';
    }

    if (!RegExp('(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\\W)').hasMatch(val)) {
      return 'Master Password must be contain at least one Capital, small letter, number';
    }
    return null;
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    
    passwordFieldVisibility = false;
    passwordFieldControllerValidator = _passwordFieldControllerValidator;
  }

  void dispose() {
    unfocusNode.dispose();
    passwordFieldController?.dispose();
  }


}
