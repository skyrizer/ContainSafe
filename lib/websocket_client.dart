import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:6001'));

  // Listen for messages from the WebSocket server
  channel.stream.listen(
        (message) {
      print('Received message: $message');
    },
    onDone: () {
      print('Connection closed.');
    },
    onError: (error) {
      print('Error: $error');
    },
  );

  // Send a message to the WebSocket server
  // Note: This may not be applicable for your setup since Laravel WebSockets typically handle broadcasting rather than direct messaging
  channel.sink.add('Hello from Dart!');

  // Close the WebSocket connection after some time
  Future.delayed(Duration(seconds: 5), () {
    channel.sink.close();
  });
}