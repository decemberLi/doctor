import 'package:dio/dio.dart';

BaseOptions _baseOptions = BaseOptions(
    baseUrl: 'https://gateway-dev.e-medclouds.com/medclouds-ucenter/mobile',
    connectTimeout: 10000);

// 定义单例
Dio http = Dio(_baseOptions);
