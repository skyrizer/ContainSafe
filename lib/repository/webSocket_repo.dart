import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketRepository {
  late WebSocketChannel channel;

  WebSocketRepository(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  Stream get messages => channel.stream;

  void close() {
    channel.sink.close(status.goingAway);
  }

  Future<bool> testConnection() async {
    Completer<bool> completer = Completer<bool>();

    channel.sink.add("ping");

    channel.stream.listen((message) {
      if (message == "pong") {
        completer.complete(true);
      }
    }, onError: (error) {
      print("Connection test failed: $error");
      completer.complete(false);
    });

    // Return the result of the completer when the connection test finishes or times out
    return completer.future.timeout(Duration(seconds: 5), onTimeout: () {
      return false;
    });
  }
}
