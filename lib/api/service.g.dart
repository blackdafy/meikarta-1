// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://easymovein.id/apieasymovein/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<ModelResponLogin> postLogin(param) async {
    ArgumentError.checkNotNull(param, 'param');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(param?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('login.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelResponLogin.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelResponMkrtUnit> postQrCode(param) async {
    ArgumentError.checkNotNull(param, 'param');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(param?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_mkrt_units.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelResponMkrtUnit.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelGeneralResponse> postQrCodeInput(param) async {
    ArgumentError.checkNotNull(param, 'param');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(param?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/post_qr_code.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelGeneralResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelGeneralResponse> getRangeInput() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_range_input.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelGeneralResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelGeneralResponse> synchronize(param) async {
    ArgumentError.checkNotNull(param, 'param');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(param?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/upload.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelGeneralResponse.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelSyncUnits> getUnits(blocks) async {
    ArgumentError.checkNotNull(blocks, 'blocks');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'blocks': blocks};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_mkrt_units_all.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelSyncUnits.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelSyncElectrics> getElectrics() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_electrics.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelSyncElectrics.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelSyncWaters> getWaters() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_waters.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelSyncWaters.fromJson(_result.data);
    return value;
  }

  @override
  Future<ModelResponMasterProblem> getMasterProblem() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>(
        'reading_qr/get_master_problem.php',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = ModelResponMasterProblem.fromJson(_result.data);
    return value;
  }
}
