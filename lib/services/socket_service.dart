// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

// ayudara a decirle a provider cuando refrescar la interface o redibujar
class SocketService with ChangeNotifier {
  IO.Socket _socket = IO.io("http://192.168.100.12:3000/");

  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    //this._initConfig();
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io("http://192.168.100.12:3000/", {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
