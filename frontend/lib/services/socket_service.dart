import 'package:flutter/material.dart';
import 'package:idocs/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends ChangeNotifier {
  IO.Socket? _socket;
  final TextEditingController textController = TextEditingController();
  bool _isUpdatingFromServer = false;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  int _userCount = 0;
  int get userCount => _userCount;

  SocketService() {
    textController.addListener(onTextChanged);
  }

  void connect() {
    if (_socket != null && _socket!.connected) {
      debugPrint('Socket already connected');
      return;
    }

    _socket = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.onConnect((_) {
      debugPrint('Connected to socket server');
      _isConnected = true;
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      debugPrint('Disconnected from socket server');
      _isConnected = false;
      notifyListeners();
    });

    _socket!.onConnectError((error) {
      debugPrint('Connection error: $error');
      _isConnected = false;
      notifyListeners();
    });

    _setupListeners();
  }

  void _setupListeners() {
    _socket!.on('init-text', (data) {
      debugPrint('Received initial text');
      if (data != null) {
        _isUpdatingFromServer = true;
        textController.text = data.toString();
        _isUpdatingFromServer = false;
      }
    });

    _socket!.on('text-change', (data) {
      debugPrint('Received text change $data');
      if (data['text'] != null) {
        _isUpdatingFromServer = true;

        final currentSelection = textController.selection;

        textController.text = data['text'].toString();

        if (currentSelection.isValid &&
            currentSelection.baseOffset <= textController.text.length) {
          textController.selection = currentSelection;
        }

        _isUpdatingFromServer = false;
      }
    });

    _socket!.on('user-count', (data) {
      _userCount = data as int;
      debugPrint('Connected users: $_userCount');
      notifyListeners();
    });
  }

  void onTextChanged() {
    if (_isUpdatingFromServer) return;

    if (_socket == null || !_socket!.connected) {
      return;
    }
    debugPrint(textController.text);
    try {
      _socket!.emit('text-update', {'text': textController.text});
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    debugPrint('Socket disconnected');
    notifyListeners();
  }

  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    disconnect();
    super.dispose();
  }
}
