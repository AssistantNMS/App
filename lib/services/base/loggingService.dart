import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:logger/logger.dart';

class LoggerService implements ILoggerService {
  Logger logger;
  LoggerService() {
    logger = Logger(
      filter: null, // Use the default LogFilter (-> only log in debug mode)
      printer: PrettyPrinter(
          methodCount: 1, // number of method calls to be displayed
          errorMethodCount:
              8, // number of method calls if stacktrace is provided
          lineLength: 120, // width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ), // Use the PrettyPrinter to format and print log
      output: null, // Use the default LogOutput (-> send everything to console)
    );
  }

  @override
  void v(String message) {
    logger.v('$message----');
  }

  @override
  void i(String message) {
    logger.i('$message----');
  }

  @override
  void d(String message) {
    logger.d('$message----');
  }

  @override
  void e(String message) {
    logger.e('$message----');
  }
}
