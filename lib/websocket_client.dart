import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  // Replace 'ws://localhost:8080' with the appropriate WebSocket server address
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));

  // Send a message to the WebSocket server
  channel.sink.add('Hello from Dart!');

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

  // Close the WebSocket connection after some time
  Future.delayed(Duration(seconds: 5), () {
    channel.sink.close();
  });
}
