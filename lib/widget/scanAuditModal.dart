import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physicalcountv2/db/models/logsModel.dart';
import 'package:physicalcountv2/db/sqfLite_dbHelper.dart';
import 'package:physicalcountv2/values/bodySize.dart';
import 'package:physicalcountv2/values/globalVariables.dart';
import 'package:physicalcountv2/widget/instantMsgModal.dart';
scanAuditModal(BuildContext context, SqfliteDBHelper db, String details) {
  late FocusNode myFocusNodeAuditEmpNo;
  myFocusNodeAuditEmpNo = FocusNode();
  myFocusNodeAuditEmpNo.requestFocus();
  final auditempnoController = TextEditingController();
  Logs _log = Logs();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("hh:mm:ss aaa");
  bool obscureAuditENumber = true;
  final validCharacters = RegExp(r'^[0-9]+$');

  return showModalBottomSheet(
    // isDismissible: false,
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: BodySize.hghth / 2.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text("SCAN AUDITOR EMPLOYEE NUMBER TO CONTINUE",
                        style: TextStyle(color: Colors.black, fontSize: 25)),
                  ),
                  TextField(
                    obscureText: obscureAuditENumber,
                    focusNode: myFocusNodeAuditEmpNo,
                    controller: auditempnoController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black, fontSize: 25),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      prefixIcon: Icon(
                        CupertinoIcons.person_alt_circle,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      hintText: 'Auditor Employee Number',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          auditempnoController.text.isNotEmpty
                              ? IconButton(
                              onPressed: () {
                                auditempnoController.clear();
                                setModalState(() {});
                              },
                                icon: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Colors.red,
                            ),
                          )
                              : SizedBox(),
                          IconButton(
                            icon: !obscureAuditENumber
                                ? Icon(CupertinoIcons.eye_fill,
                                color: Colors.blueGrey[900])
                                : Icon(CupertinoIcons.eye_slash_fill,
                                color: Colors.blueGrey[900]),
                            onPressed: () {
                              obscureAuditENumber = !obscureAuditENumber;
                              setModalState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {});
                    },
                    onSubmitted: (value) async {
                      if (value.isNotEmpty) {
                        if(validCharacters.hasMatch(value)==false){
                          instantMsgModal(
                              context,
                              Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: Colors.red,
                                size: 40,
                              ),
                              Text("Invalid Input."));
                          auditempnoController.clear();
                          myFocusNodeAuditEmpNo.requestFocus();
                        }
                        var ls = await db.selectAuditWhere(
                            auditempnoController.text.trim(),
                            GlobalVariables.currentLocationID);

                        print('LOCATION ID:  ${GlobalVariables.currentLocationID} ');

                        if (ls != null && ls.isNotEmpty) {
                          GlobalVariables.logAuditName= ls[0]['name'];
                          //logs
                          _log.date    = dateFormat.format(DateTime.now());
                          _log.time    = timeFormat.format(DateTime.now());
                          _log.device  = "${GlobalVariables.deviceInfo}(${GlobalVariables.readdeviceInfo})";
                          _log.user    = "${GlobalVariables.logAuditName} [AUDIT] ";
                          _log.empid   = auditempnoController.text.trim();
                          _log.details = details.toString();
                          await db.insertLog(_log);
                          GlobalVariables.isAuditLogged = true;
                          Navigator.pop(context);
                        } else {
                          print("mao ni ls");
                          print(ls);
                          instantMsgModal(
                              context,
                              Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: Colors.red,
                                size: 40,
                              ),
                              Text("Invalid Audit Employee."));
                          auditempnoController.clear();
                          myFocusNodeAuditEmpNo.requestFocus();
                        }
                      } else {
                        instantMsgModal(
                            context,
                            Icon(
                              CupertinoIcons.exclamationmark_circle,
                              color: Colors.red,
                              size: 40,
                            ),
                            Text("Audit Employee Number not found."));
                        auditempnoController.clear();
                        myFocusNodeAuditEmpNo.requestFocus();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
