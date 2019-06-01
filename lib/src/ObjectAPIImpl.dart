import 'package:kiilib_core/kiilib_core.dart';
import 'dart:convert';

import '../kiilib_object.dart';

class ObjectAPIImpl implements ObjectAPI {
  final KiiContext context;

  ObjectAPIImpl(this.context);

  @override
  Future<KiiObject> create(KiiBucket bucket, Map<String, dynamic> body) async {
    var url =
        "${this.context.baseURL}/apps/${this.context.appID}${bucket.path}/objects";
    var headers = this.context.makeAuthHeader();
    headers["Content-Type"] = "application/json";

    var response =
        await this.context.client.sendJson(Method.POST, url, headers, body);
    if (response.status != 201) {
      print(response.body);
      throw Exception("Error");
    }

    var bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    var objectID = bodyJson["objectID"] as String;
    var object = KiiObject.withId(bucket, objectID);
    object.replace(bodyJson);
    return object;
  }

  @override
  Future<KiiObject> getById(KiiBucket bucket, String id) async {
    var url =
        "${this.context.baseURL}/apps/${this.context.appID}${bucket.path}/objects/${id}";
    var headers = this.context.makeAuthHeader();

    var response =
        await this.context.client.sendJson(Method.GET, url, headers, null);
    if (response.status != 200) {
      print(response.body);
      throw Exception("Error");
    }

    var bodyJson = jsonDecode(response.body) as Map<String, dynamic>;
    var objectID = bodyJson["_id"] as String;
    var object = KiiObject.withId(bucket, objectID);
    object.replace(bodyJson);
    return object;
  }

  @override
  Future<KiiObject> update(KiiObject object) async {
    var url =
        "${this.context.baseURL}/apps/${this.context.appID}${object.path}";
    var headers = this.context.makeAuthHeader();
    headers["Content-Type"] = "application/json";

    var response = await this
        .context
        .client
        .sendJson(Method.PUT, url, headers, object.body);
    if (response.status == 200) {
      return object;
    } else if (response.status == 201) {
      return object;
    } else {
      print(response.body);
      throw Exception("Error");
    }
  }

  @override
  Future<KiiObject> updatePatch(KiiObject object, Map<String, dynamic> patch) {
    // TODO: implement updatePatch
    return null;
  }

  @override
  Future<bool> delete(KiiObject object) async {
    var url =
        "${this.context.baseURL}/apps/${this.context.appID}${object.path}";
    var headers = this.context.makeAuthHeader();

    var response =
        await this.context.client.sendJson(Method.DELETE, url, headers, null);
    if (response.status != 204) {
      print(response.body);
      throw Exception("Error");
    }
    return true;
  }
}
