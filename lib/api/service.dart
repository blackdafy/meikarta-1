import 'package:dio/dio.dart';
import 'package:easymoveinapp/api/base_url.dart';
import 'package:easymoveinapp/models/auth/post_model_login.dart';
import 'package:easymoveinapp/models/auth/res_model_login.dart';
import 'package:easymoveinapp/models/general_response.dart';
import 'package:easymoveinapp/models/post_qrcode.dart';
import 'package:easymoveinapp/models/post_qrcode_list.dart';
import 'package:easymoveinapp/models/post_search_by_qr.dart';
import 'package:easymoveinapp/models/res_mkrt_unit.dart';
import 'package:easymoveinapp/models/sync/res_electrics.dart';
import 'package:easymoveinapp/models/sync/res_units.dart';
import 'package:easymoveinapp/models/sync/res_waters.dart';
import 'package:retrofit/retrofit.dart';

part 'service.g.dart';

RestClient getClient({String header}) {
  final dio = Dio();
  // dio.options.headers["Content-Type"] =
  //     header == null || header.isEmpty ? "application/json" : header;
  dio.options.connectTimeout = BaseUrl.connectTimeout;
  RestClient client = RestClient(dio);
  return client;
}

@RestApi(baseUrl: BaseUrl.MainUrls)
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @POST("login.php")
  Future<ModelResponLogin> postLogin(@Body() ModelPostLogin param);

  @POST("get_mkrt_units.php")
  Future<ModelResponMkrtUnit> postQrCode(@Body() ModelPostQr param);

  @POST("post_qr_code.php")
  Future<ModelGeneralResponse> postQrCodeInput(@Body() ModelPostQrCode param);

  @GET("get_range_input.php")
  Future<ModelGeneralResponse> getRangeInput();

  @POST("upload.php")
  Future<ModelGeneralResponse> synchronize(@Body() ModelPostQrCodeList param);

  @GET("get_mkrt_units_all.php")
  Future<ModelSyncUnits> getUnits();

  @GET("get_electrics.php")
  Future<ModelSyncElectrics> getElectrics();

  @GET("get_waters.php")
  Future<ModelSyncWaters> getWaters();
}
