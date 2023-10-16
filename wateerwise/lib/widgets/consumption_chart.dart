import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wateerwise/components/Graphs/HomeGraphs/consumptionGraph.dart';
import 'package:wateerwise/constant.dart';

class ConsumptionChart extends StatelessWidget {
  final List<double> consumptionData;
  final bool showAvg;
  final GraphView currentView;
  final int currentStartIndex;
  final DateTime currentDate;
  final List<String> months;

  const ConsumptionChart({
    Key? key,
    required this.consumptionData,
    required this.showAvg,
    required this.currentView,
    required this.currentStartIndex,
    required this.currentDate,
    required this.months,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          showAvg ? avgData() : mainData(),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = '';
    int index = currentStartIndex + value.toInt();
    int currentYear = currentDate.year;
    switch (currentView) {
      case GraphView.day:
        // Display hours for the day
        text = "$index:00"; // Assuming value represents hours
        break;
      case GraphView.month:
        if (index < consumptionData.length) {
          text = "${index + 1} ${months[currentDate.month - 1]}, $currentYear";
        }
        break;
      case GraphView.year:
        if (index < months.length) {
          text = months[index];
        }
        break;
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0m\u00B3';
        break;
      case 1:
        text = '10m\u00B3';
        break;
      case 2:
        text = '15m\u00B3';
        break;
      case 3:
        text = '20m\u00B3';
        break;
      case 4:
        text = '25m\u00B3';
        break;
      case 5:
        text = '30m\u00B3';
        break;
      case 6:
        text = '40m\u00B3';
        break;
      default:
        text = '';
        break;
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 2.8,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: tGray,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: tGray,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: tBlackG),
      ),
      minX: 0,
      maxX: (consumptionData.length - 1).toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          // Replace hardcoded FlSpot values with dynamic values
          spots: List.generate(consumptionData.length, (index) {
            return FlSpot(index.toDouble(), consumptionData[index]);
          }),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    // Calculate the average of consumptionData
    double avg = consumptionData.isNotEmpty
        ? consumptionData.reduce((a, b) => a + b) / consumptionData.length
        : 0;

    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: (consumptionData.length - 1).toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          // Create a line that represents the average consumption
          spots: List.generate(consumptionData.length, (index) {
            return FlSpot(index.toDouble(), avg);
          }),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
