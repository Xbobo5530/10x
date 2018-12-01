import 'package:scoped_model/scoped_model.dart';
import 'package:tatua/src/models/breakdown_model.dart';
import 'package:tatua/src/models/draw_model.dart';
import 'package:tatua/src/models/rundown_model.dart';

const _tag = 'MainModel:';

class MainModel extends Model with DrawModel, RundownModel, BreakdownModel {}

enum StatusCode { success, waiting, failed }
