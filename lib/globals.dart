library my_prj.globals;

import 'package:doctor_app/models/user.dart';

String url = 'https://vlcd4zu2.directus.app';
String token = '';
String refresh_token = '';
var user;

String avatar_placeholder_id = '9c38b55b-70a9-43f5-aad6-0bd1862143ad';
String avatar_placeholder_url = '$url/assets/$avatar_placeholder_id';

int minutes_for_appointment = 30;
