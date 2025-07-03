import '../models/dashboard.dart';
import 'package:flutter/material.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  
  const WeatherWidget({Key? key, required this.weather}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.blue.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        weather.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${weather.condition} • ${weather.temperature}°C',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _getWeatherIcon(),
                  SizedBox(width: 8),
                  Icon(
                    Icons.water_drop,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            weather.isGoodForFarming
                ? 'Good day for farming!'
                : 'Not ideal for farming today.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            weather.farmingTip,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _getWeatherIcon() {
    IconData iconData;
    
    switch (weather.condition.toLowerCase()) {
      case 'sunny':
        iconData = Icons.wb_sunny;
        break;
      case 'partly cloudy':
        iconData = Icons.wb_cloudy;
        break;
      case 'cloudy':
        iconData = Icons.cloud;
        break;
      case 'rainy':
      case 'scattered showers':
        iconData = Icons.water_drop;
        break;
      default:
        iconData = Icons.wb_sunny;
    }
    
    return Icon(
      iconData,
      color: Colors.white,
      size: 32,
    );
  }
}
