import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'ConstantWidget.dart';
import 'Constants.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget(
      {
    super.key,
    Color? gradientColor1,
    Color? gradientColor2,
    Color? gradientColor3,
    Color? indicatorStrokeColor,
  })  : gradientColor1 = gradientColor1 ?? Colors.lightBlue,
        gradientColor2 = gradientColor2 ?? Colors.pink,
        gradientColor3 = gradientColor3 ?? Colors.red,
        indicatorStrokeColor = indicatorStrokeColor ?? Colors.white;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color gradientColor3;
  final Color indicatorStrokeColor;

  @override
  State<LineChartWidget> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartWidget> {
  String getTitle(){
    var date = DateTime.now();
    var newDate = new DateTime(date.year, date.month, date.day+30);
    List<String> months = ["Jan","Fev","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    int month = newDate.month;
    int day = newDate.day;
    String dayString = day.toString();
    if(day<10) dayString="0"+day.toString();
    String dateString = months[month]+"\n"+dayString;

    return dateString;
  }
  List<int> showingTooltipOnSpots = [1, 2];

  List<FlSpot> get allSpots => const [
    FlSpot(0, 3),
    //FlSpot(5, 5),
    FlSpot(1, 2.5),
    //FlSpot(3, 3),
    FlSpot(2, 1.5),
    //FlSpot(1, 2),
    FlSpot(3, 1),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.pink,
      fontFamily: 'Digital',
      fontSize: 18 * chartWidth / 500,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '';
        break;
      case 1:
        text = '';
        break;
      case 2:
        text = '';
        break;
      case 3:
        text = '';
        break;
      case 4:
        text = '';
        break;
      case 5:
        text = '';
        break;
      case 6:
        text = '';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        barWidth: 4,
        shadow: const Shadow(
          blurRadius: 8,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              widget.gradientColor1.withOpacity(0.4),
              widget.gradientColor2.withOpacity(0.4),
              widget.gradientColor3.withOpacity(0.4),
            ],
          ),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: [
            widget.gradientColor1,
            widget.gradientColor2,
            widget.gradientColor3,
          ],
          stops: const [0.1, 0.4, 0.9],
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Column(
      children: [
        Text("Take up the challenge and you'll be", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
        SizedBox(height: 5,),
        Text(sharedDesiredWeight+" by "+getTitle().replaceAll("\n", " "), style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.pink)),
        SizedBox(
          height:  ConstantWidget.getScreenPercentSize(context, 13),
        ),
        Container(
          child: Expanded(
            child: LineChart(
              LineChartData(
                showingTooltipIndicators: showingTooltipOnSpots.map((index) {
                  return ShowingTooltipIndicators([
                    LineBarSpot(
                      tooltipsOnBar,
                      lineBarsData.indexOf(tooltipsOnBar),
                      tooltipsOnBar.spots[index],
                    ),
                  ]);
                }).toList(),
                lineTouchData: LineTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.pink,
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                                radius: 8,
                                color: lerpGradient(
                                  barData.gradient!.colors,
                                  barData.gradient!.stops!,
                                  percent / 100,
                                ),
                                strokeWidth: 2,
                                strokeColor: widget.indicatorStrokeColor,
                              ),
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.pink,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        return LineTooltipItem(
                          lineBarSpot.y.toString()=="2.5"?"Today":getTitle(),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: lineBarSpot.y.toString()=="2.5"?FontWeight.w100:FontWeight.bold,
                            fontSize: lineBarSpot.y.toString()=="2.5"?15:20
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: lineBarsData,
                minY: 0,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                    axisNameSize: 24,
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 0,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return bottomTitleWidgets(
                          value,
                          meta,
                          20//constraints.maxWidth,
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    axisNameWidget: const Text(''),
                    sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 0,
                    ),
                  ),
                  topTitles: AxisTitles(
                    axisNameWidget: const Text(
                      '',
                      textAlign: TextAlign.left,
                    ),
                    axisNameSize: 24,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 0,
                    ),
                  ),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height:  ConstantWidget.getScreenPercentSize(context, 7),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Text("Let's do it", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black))),
      ],
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}