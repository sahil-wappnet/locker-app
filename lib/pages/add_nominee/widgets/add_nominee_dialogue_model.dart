// import '/flutter_flow/flutter_flow_util.dart';
// import 'package:flutter/material.dart';

// class AddNomineeDialogueueModel extends FlutterFlowModel {

//   final unfocusNode = FocusNode();
//   final formKey = GlobalKey<FormState>();

//   TextEditingController? emailAddressFieldController;
//   String? Function(BuildContext, String?)? emailAddressFieldControllerValidator;
//   String? _emailAddressFieldControllerValidator(
//       BuildContext context, String? val) {
//     if (val == null || val.isEmpty) {
//       return 'Field is required';
//     }

//     if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
//       return 'Please Enter valid email';
//     }
//     return null;
//   }


//   /// Initialization and disposal methods.

//   void initState(BuildContext context) {
//     emailAddressFieldControllerValidator =
//         _emailAddressFieldControllerValidator;
    
//   }

//   void dispose() {
//     unfocusNode.dispose();
//         emailAddressFieldController?.dispose();

//   }


// }
