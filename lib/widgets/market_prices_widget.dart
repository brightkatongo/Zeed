import '../models/dashboard.dart';
import 'package:flutter/material.dart';

class MarketPricesWidget extends StatelessWidget {
  final List<MarketPrice> marketPrices;
  
  const MarketPricesWidget({Key? key, required this.marketPrices}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: marketPrices.length,
        itemBuilder: (context, index) {
          final price = marketPrices[index];
          return Container(
            width: 150,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _getProductIcon(price.name),
                    SizedBox(width: 8),
                    Text(
                      price.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  'K${price.price}/${price.unit}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      price.isUp ? Icons.trending_up : Icons.trending_down,
                      color: price.isUp ? Colors.green : Colors.red,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      price.trend,
                      style: TextStyle(
                        color: price.isUp ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _getProductIcon(String productName) {
    String emoji;
    
    switch (productName.toLowerCase()) {
      case 'maize':
        emoji = '🌽';
        break;
      case 'soya beans':
        emoji = '🌱';
        break;
      case 'groundnuts':
        emoji = '🥜';
        break;
      case 'tomatoes':
        emoji = '🍅';
        break;
      case 'sweet potatoes':
        emoji = '🍠';
        break;
      default:
        emoji = '🌾';
    }
    
    return Text(
      emoji,
      style: TextStyle(fontSize: 20),
    );
  }
}
