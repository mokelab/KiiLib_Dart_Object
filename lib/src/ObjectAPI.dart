import 'package:kiilib_core/kiilib_core.dart';

abstract class ObjectAPI {
  Future<KiiObject> create(KiiBucket bucket, Map<String, dynamic> body);
  Future<KiiObject> getById(KiiBucket bucket, String id);
  Future<KiiObject> update(KiiObject object);
  Future<KiiObject> updatePatch(KiiObject object, Map<String, dynamic> patch);
  Future<bool> delete(KiiObject object);
}
