import 'package:intl/intl.dart';

class AppFormatters {
  static final NumberFormat currency = NumberFormat.currency(symbol: '\$');
  static final DateFormat dateTime = DateFormat('MMM d, yyyy • h:mm a');
  static final DateFormat shortDateTime = DateFormat('MMM d, h:mm a');
  static final DateFormat dateOnly = DateFormat('MMM d, yyyy');
  static final DateFormat timeOnly = DateFormat('h:mm a');
}
