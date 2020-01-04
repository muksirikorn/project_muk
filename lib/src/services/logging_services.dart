import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(),
);

Logger loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
