


import 'package:encrypt/encrypt.dart';

import '../../auth/firebase_auth/auth_util.dart';
import '../../utils/deriveEncryptionKey_function.dart';
import '../dialogue/custom_dialogue.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:pointycastle/export.dart' as expostdata;
import '/flutter_flow/flutter_flow_util.dart';
import '/pages/dialogue/dialogue_widget.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'bottom_sheet1_model.dart';
export 'bottom_sheet1_model.dart';

class BottomSheet1Widget extends StatefulWidget {
  const BottomSheet1Widget({
    required this.datRef,
  });

  final DocumentReference? datRef;

  @override
  _BottomSheet1WidgetState createState() => _BottomSheet1WidgetState();
}

class _BottomSheet1WidgetState extends State<BottomSheet1Widget> {
  late BottomSheet1Model _model;
    String? privateKey;

    String? encryptedEnencryptionKey;


  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
   
    _model = createModel(context, () => BottomSheet1Model());
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  expostdata.RSAPrivateKey parsePrivateKey(String privateKeyPEM) {
    final rsaParser = RSAKeyParser();
    final privateKey = rsaParser.parse(privateKeyPEM) as expostdata.RSAPrivateKey;
    return privateKey;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  


 
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DetailDataRecord>(
      stream: DetailDataRecord.getDocument(widget.datRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
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
        }
        final bottomSheetMaterialDetailDataRecord = snapshot.data!;
        return Container(
          height: MediaQuery.sizeOf(context).height / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 8.0),
                  child: Text(
                    bottomSheetMaterialDetailDataRecord.displayTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: FlutterFlowTheme.of(context).headlineSmall,
                  ),
                ),
                
                // Padding(
                //   padding: EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 8.0),
                //   child: Text(
                //     bottomSheetMaterialDetailDataRecord.dataTitle,
                //     style: FlutterFlowTheme.of(context).bodySmall,
                //   ),
                // ),
                // Container(
                //   width: double.infinity,
                //   height: 60.0,
                //   decoration: BoxDecoration(),
                //   child: Padding(
                //     padding:
                //         EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       children: [
                //         Card(
                //           clipBehavior: Clip.antiAliasWithSaveLayer,
                //           color: FlutterFlowTheme.of(context).primaryBackground,
                //           elevation: 0.0,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(40.0),
                //           ),
                //           child: Padding(
                //             padding: EdgeInsetsDirectional.fromSTEB(
                //                 8.0, 8.0, 8.0, 8.0),
                //             child: Icon(
                //               Icons.share_rounded,
                //               color: FlutterFlowTheme.of(context).secondaryText,
                //               size: 20.0,
                //             ),
                //           ),
                //         ),
                // Expanded(
                //   child: Padding(
                //     padding: EdgeInsetsDirectional.fromSTEB(
                //         12.0, 0.0, 0.0, 0.0),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.max,
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           'Share',
                //           style: FlutterFlowTheme.of(context)
                //               .titleSmall
                //               .override(
                //                 fontFamily: 'Roboto Slab',
                //                 color: FlutterFlowTheme.of(context)
                //                     .secondaryText,
                //               ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
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
                            Map<String, dynamic> userData =
                                userSnapshot.data() as Map<String, dynamic>;

                            ConstanData.encryptionKey =
                                userData['encryptionKey'];
                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(param: widget.datRef);
                              },
                            );
                          }
                        } catch (e) {
                          print('Error fetching user email: $e');
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 8.0, 8.0, 8.0),
                              child: Icon(
                                Icons.mode_edit,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 20.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 0.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Edit',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Roboto Slab',
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(),
                  child: Builder(
                    builder: (context) => Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 8.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          Navigator.pop(context);
                          await showAlignedDialog(
                            barrierColor: Color(0x00FF0000),
                            context: context,
                            isGlobal: true,
                            avoidOverflow: false,
                            targetAnchor: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            followerAnchor: AlignmentDirectional(0.0, 0.0)
                                .resolve(Directionality.of(context)),
                            builder: (dialogContext) {
                              return Material(
                                color: Colors.transparent,
                                child: Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.35,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.75,
                                  child: DialogueWidget(
                                    dataRef: widget.datRef!,
                                  ),
                                ),
                              );
                            },
                          ).then((value) => setState(() {}));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    8.0, 8.0, 8.0, 8.0),
                                child: Icon(
                                  Icons.delete_outline,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Delete',
                                      style: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Roboto Slab',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
