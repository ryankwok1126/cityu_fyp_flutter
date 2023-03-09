import 'package:cityu_fyp_flutter/my_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReportLineChart extends StatefulWidget {
  const ReportLineChart(
      {super.key, required this.overviewData, required this.studentData});

  final List<FlSpot> overviewData;
  final List<FlSpot> studentData;

  @override
  State<ReportLineChart> createState() => _ReportOverviewState();
}

class _ReportOverviewState extends State<ReportLineChart> {
  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: widget.overviewData.length.toDouble(),
        maxY: 2.3,
        minY: -0.3,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles,
        ),
      );

  List<LineChartBarData> get lineBarsData => [
        lineChartBarData1,
        lineChartBarData2,
      ];

  FlGridData get gridData => FlGridData(
        show: true,
        verticalInterval: 5,
        horizontalInterval: 1,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      color: Color(0xff2f2f2f),
    );
    String text;
    if (value % 1 == 0) {
      text = value.toInt().toString();
    } else {
      text = '';
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles get leftTitles => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 14,
      color: Color(0xff2f2f2f),
    );
    Widget text;

    if (value % 5 == 0) {
      text = Text(value.toInt().toString(), style: style);
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 26,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: MyColors.darkGrey, width: 1),
          left: BorderSide(color: MyColors.darkGrey, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1 => LineChartBarData(
        isCurved: true,
        color: MyColors.lightGreen,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(
          show: false,
          color: MyColors.lightGreen.withOpacity(0.2),
        ),
        spots: widget.overviewData,
      );

  LineChartBarData get lineChartBarData2 => LineChartBarData(
        isCurved: true,
        color: MyColors.darkGreen,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: widget.studentData,
      );

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
    );
  }
}
