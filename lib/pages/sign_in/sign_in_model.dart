import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class SignInModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for EmailAddressField widget.
  TextEditingController? emailAddressFieldController;
  String? Function(BuildContext, String?)? emailAddressFieldControllerValidator;
  String? _emailAddressFieldControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Please Enter valid email';
    }
    return null;
  }

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
      return 'Master Password must be contain at least one Capital, small letter, number, special character';
    }
    return null;
  }

  // State field(s) for ConfirmPasswordField widget.
  TextEditingController? confirmPasswordFieldController;
  late bool confirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordFieldControllerValidator;
  String? _confirmPasswordFieldControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 12) {
      return 'Master Password is at least 12 character Long';
    }

    if (!RegExp('(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\\W)').hasMatch(val)) {
      return 'Master Password should contain atleast one Capital, small letter, number, special character';
    }
    return null;
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    emailAddressFieldControllerValidator =
        _emailAddressFieldControllerValidator;
    passwordFieldVisibility = false;
    passwordFieldControllerValidator = _passwordFieldControllerValidator;
    confirmPasswordFieldVisibility = false;
    confirmPasswordFieldControllerValidator =
        _confirmPasswordFieldControllerValidator;
  }

  void dispose() {
    unfocusNode.dispose();
    emailAddressFieldController?.dispose();
    passwordFieldController?.dispose();
    confirmPasswordFieldController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
