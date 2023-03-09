import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportPieChart extends StatefulWidget {
  const ReportPieChart(
      {super.key,
      required this.focus,
      required this.notFocus,
      required this.undefine});

  final int focus;
  final int notFocus;
  final int undefine;

  @override
  State<ReportPieChart> createState() => _ReportPieChartState();
}

class _ReportPieChartState extends State<ReportPieChart> {
  int touchedIndex = -1;
  int _total = 0;

  _countTotal() {
    _total = widget.focus + widget.notFocus + widget.undefine;
    print(widget.focus);
    print(widget.notFocus);
    print(widget.undefine);
    print(_total);
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 36.0 : 24.0;
      final radius = isTouched
          ? MediaQuery.of(context).size.height / 10
          : MediaQuery.of(context).size.height / 13;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff67c587),
            value: widget.focus.toDouble(),
            title: '${(widget.focus / _total * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffc9ead4),
            value: widget.notFocus.toDouble(),
            title: '${(widget.notFocus / _total * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xffeaf6ed),
            value: widget.undefine.toDouble(),
            title: '${(widget.undefine / _total * 100).toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  @override
  void initState() {
    _countTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 50,
        startDegreeOffset: -90,
        sections: showingSections(),
      ),
    );
  }
}
