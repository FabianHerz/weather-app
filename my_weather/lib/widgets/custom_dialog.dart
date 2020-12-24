import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_weather/helpers/size_config_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_weather/styles/main_colors.dart' as clr;


class CustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final VoidCallback negative;
  final VoidCallback positive;
  final String negativeText;
  final String positiveText;
  final List<String> titleParams;
  final List<String> contentParams;

  @override
  State<StatefulWidget> createState() {
    return CustomDialogState();
  }

  CustomDialog(
      {Key key,
        this.title,
        this.content,
        this.negative,
        this.positive,
        this.negativeText,
        this.positiveText,
        this.titleParams,
        this.contentParams
      })
      : super(key: key);
}

class CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: ClipRRect(

        borderRadius: BorderRadius.all(Radius.circular(15.0)),
        child: Container(
          color: clr.view,
            constraints: BoxConstraints(maxWidth: 400),
            child: Wrap(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Center(
                        child: Text(
                            widget.title,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: "Segoe",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: clr.textLight,

                          ),
                        ).tr(args:widget.titleParams),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:10.0),
                      child: Container(
                        height: 100,
                        child: Center(
                          child: Text(
                              widget.content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Segoe",
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: clr.text,

                            ),
                          ).tr(args:widget.contentParams),
                        ),
                      ),
                    ),
                    // widget.content,
                    Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.negativeText,
                                  style:TextStyle(
                                    fontFamily: "Segoe",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: clr.textLight,

                                  ),
                                ).tr(),
                                color: clr.view,
                              ),
                              onTap: widget.negative,
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          ),
                          Container(
                            height: 70,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Flexible(
                            child: GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.positiveText,
                                  style: TextStyle(
                                    fontFamily: "Segoe",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: clr.textLight,

                                  ),
                                ).tr(),
                                color: clr.view,
                              ),
                              onTap: widget.positive,
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}