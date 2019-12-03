// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/custom_icons_icons.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.text: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black54,
  _Element.text: Colors.white,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      //_timer = Timer(
      //  Duration(minutes: 1) -
      //      Duration(seconds: _dateTime.second) -
      //      Duration(milliseconds: _dateTime.millisecond),
      //  _updateTime,
      //);
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final seconds = DateFormat('ss').format(_dateTime);
    final meridium = DateFormat('a').format(_dateTime);
    final day = DateFormat('E').format(_dateTime).substring(0, 2).toUpperCase();
    final fontSize = MediaQuery.of(context).size.width / 8.5;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Questrial',
      fontSize: fontSize,
    );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(day),
                      Text(
                        'DAY',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                  Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(hour),
                      Text(
                        'HOURS',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 0.01),
                      ),
                    ],
                  ),
                  Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(minute),
                      Text(
                        'MINUTES',
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w200,
                            letterSpacing: 0.01),
                      ),
                    ],
                  ),
                  Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(seconds),
                      Text(
                        'SECONDS',
                        style:
                            TextStyle(fontSize: 9, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: widget.model.is24HourFormat
                        ? (int.parse(hour) > 18 || int.parse(hour) < 6
                            ? Icon(CustomIcons.moon_inv)
                            : Icon(Icons.wb_sunny))
                        : Text(
                            meridium,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w200),
                          ),
                  ),
                  /*Positioned(left: offset, top: 0, child: Text(hour)),
                  Positioned(right:30,top: 30,child: Text(':'),),
                  Positioned(right: offset, bottom: offset, child: Text(minute)),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
