import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../setUp/size/app_size.dart';

import '../../../domain/entities/shop/analytic_product_entity.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key, required this.analytics});

  final AnalyticProductEntity analytics;

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  String _selectedPeriod = 'This Week';
  Map<String, int> _data = {};

  @override
  void initState() {
    super.initState();
    _data = widget.analytics.thisWeekViews;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.chartScreen_productViews,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _selectedPeriod,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPeriod = newValue!;
                    _data = newValue == 'This Week'
                        ? widget.analytics.thisWeekViews
                        : newValue == 'This Month'
                            ? widget.analytics.thisMonthViews
                            : widget.analytics.thisYearViews;
                  });
                },
                items: <String>['This Week', 'This Month', 'This Year']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'This Week'
                          ? AppLocalizations.of(context)!.chartScreen_thisWeek
                          : value == 'This Month'
                              ? AppLocalizations.of(context)!
                                  .chartScreen_thisMonth
                              : AppLocalizations.of(context)!
                                  .chartScreen_thisYear,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _data.entries
                        .map((entry) => FlSpot(
                            _data.keys.toList().indexOf(entry.key).toDouble(),
                            entry.value.toDouble()))
                        .toList(),
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.6),
                    ),
                  ),
                ],
                minY: 0,
                maxY: _getMaxY(),
                minX: 0,
                maxX: _data.length.toDouble() - 1,
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final index = barSpot.x.toInt();
                        return LineTooltipItem(
                          '${_data.keys.elementAt(index)}\n${barSpot.y.toInt()}',
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: const FlTitlesData(
                  bottomTitles: AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    drawBelowEverything: false,
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    drawBelowEverything: false,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    drawBelowEverything: false,
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.xLargeSize),
        ],
      ),
    );
  }

  double _getMaxY() {
    return (_data.values.reduce((a, b) => a > b ? a : b).toDouble() * 1.2)
        .ceilToDouble();
  }
}
