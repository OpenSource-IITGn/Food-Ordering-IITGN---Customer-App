


import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:shared_preferences/shared_preferences.dart';

String spreadSheetID = '1yJQ1ZGwUImeO1tssVqDw7ZdVeERnkgk-uwEbaUm8-pc';

final _credentials = new auth.ServiceAccountCredentials.fromJson(r'''
enter your credential json here

''');

final scopes = [sheets.SheetsApi.SpreadsheetsScope];


Future writeData(var data, String range) async { //range is like sheetname!A:J

  auth.clientViaServiceAccount(_credentials, scopes).then((client) {
    auth
        .obtainAccessCredentialsViaServiceAccount(_credentials, scopes, client)
        .then((auth.AccessCredentials cred) {
      SheetsApi api = new SheetsApi(client);
      ValueRange vr = new sheets.ValueRange.fromJson({
        "values": data //data is [[row1],[row2], ...]
      });
      api.spreadsheets.values
          .append(vr, spreadSheetID, range,
              valueInputOption: 'USER_ENTERED')
          .then((AppendValuesResponse r) {
        client.close();
      });
    });
  });
}

Future<List> getData(String range) async {
  var returnval;
  await auth.clientViaServiceAccount(_credentials, scopes).then((client) async {
    await auth
        .obtainAccessCredentialsViaServiceAccount(_credentials, scopes, client)
        .then((auth.AccessCredentials cred) async {
      SheetsApi api = new SheetsApi(client);
      await api.spreadsheets.values.get(spreadSheetID, range).then((qs) {
        print(qs.values);
        returnval = qs.values;
      });
    });
  });
  return returnval;
}

