import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final dio = Dio();

class MarcarPontoDAO {
  Future setMarcarPonto(int idUsuario) async {
    var response;
    var url = 'http://192.168.56.1:9000/setdatahora';
    dio.options.headers = {
      'accept': 'application/json',
      'content-type': 'application/json'
    };

    try {
      response = await dio.post(
        url,
        data: json.encode({
          'id': idUsuario,
        }),
      );
    } finally {
      print(response.body);
      dio.close();
    }

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Ponto registrado",
        backgroundColor: Colors.green,
      );
      return true;
    } else {
      return false;
    }
  }
}
