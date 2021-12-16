


import 'package:googleapis/sheets/v4.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:shared_preferences/shared_preferences.dart';

String spreadSheetID = '1yJQ1ZGwUImeO1tssVqDw7ZdVeERnkgk-uwEbaUm8-pc';

final _credentials = new auth.ServiceAccountCredentials.fromJson(r'''
{
  "type": "service_account",
  "project_id": "iitgn-food-processing",
  "private_key_id": "43ed3eb52d2cc268683392d3e3ba32d5fde12e50",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDgRLfHo61r2DXm\nm7PoYbWhVYokHtGdg7IDppnqWNZ9kPMJyG6jiGMD/B0A57Rt3VPexECBKX1wlxLl\niyBHw91YcZmUgow+m3cw5DNyZdLPeQ/woRJTKQO72ga1kGLU3suY2CsKyxsHtUI8\nL/pBMKZnUrWmjPwXbyW6HVkKiqjHTcqFma+3aau0hi+Q4wkx0JyGuALAcQH6PFbA\nAG+niHsKhcAlAm0W7uvUS8xFh/uoEsZup6D7znK7INHyOvQQqsf/35F7x7SqRkoj\nfGXw0D+ay72d6f/sWyahlfQqtQFe+l0sarC+YuBZ5doUPD6JszJ7hFaA4bxko/T4\nszIKj2jRAgMBAAECggEAGZyvclzGdu0DxtjcVHsoL4sh0hs07Cy4nUMfC8zmfgOa\nRfE+dW2jhTZ7J3nOuMdQhz3ZcgbHfR67uTxIzPlY43thwzyfgJznoU1GdNedGjWk\ntOHoQlgKRZ9SKdUZ/F6PWN7DF6H3bcttC4udJGnGb0FaXnF2bsSyRc2JODN6r/wD\nBgPBFVzgukEoJ7S59osa+AXZcDvNTEhwTc5cUhQddciFH9Z6iY3PXeGhnRNKd0W/\nDG3n8peLInJzgZ82ub/uktU2vRkrjQ2ulFd5a3iqFohdMX+KAKOlTeCxO1IcAKZ3\njsft9UNVfJFygCj41UFQMttyO4bmuaSJKFKm1bumQwKBgQD9sfzMvVs6hZP9Xbj9\nsIOHlsg0oPwUKx4uEZ+2Flet31uaUm8pGhHSBMXpklDFltuVPcAqjPd2k/XHZDBu\nM71J1xHzwQ4P/yRZrEvoISB9Lncr6Jus1S68vsMg8hF4d0D3gvcN+mikMRoyajug\nzHRNQh0p6vHhww6vAmeDauBnDwKBgQDiTksM1qgVYBEnYQTO3oWWHxfcAcJqxUJK\n4HbIOcRxGEjiGnxWB30/LAcgKFnBf25IqoSiYpy17rYiK5PJ8oWsK/3OoWZ0NfnQ\nPp03kz7DsvaaXdacR/F/xpr3VxpZN0RGgruyDFN7Wsl2qcOP7h5EL5TeH2GXQ83J\nAKYctp4yHwKBgQCGJ3jnS7rSV5DKiqUogg8LxFBahEbI44QyGF+8ilQTPenS0YS2\n13JU/PErcpQD6KJ1aRIVbjXuHo/5wKFbpUCTq4dyvsQQ8XrncJUzS1FC4S9jqL2p\nx5HPfZDx+xACBA321OqQGbr8GHsh7ctaXMOjlzKU2AjQubUqFrtmYz4HQQKBgDCq\nH29yVZDLKMUsEsmdhmKC6zGPW0x0gM3zOPfTnE+ppjqg8W3ajG9iO2IJ60s16PRN\nXtpAlGx3Gcl9T3mU4nPkvd6KTKre1IqYfFxwGIYi3O7TEQxoWCFfBwH7RBo9TTxQ\nbqZaCjWzjzEqTniL/wwwozWkz+qkVQNNVWtFRf2HAoGBAJKMpzIpKOjI4ZWHQDBo\nPaYvU5FT8qiOTJy3X5NSeq6+meNZPnw7XxxkBxNkk1JjufhhukLtssac9U3EOf3B\nLltMYY4wQEALVYSiSAh2di9PO4DwIGj8J87xsKo+11rOSc3TBXA2U8p6hCq2edsO\ntrzvB25unQNrPv4VgP02qfnP\n-----END PRIVATE KEY-----\n",
  "client_email": "iitgnfood@iitgn-food-processing.iam.gserviceaccount.com",
  "client_id": "116533590682295894808",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/iitgnfood%40iitgn-food-processing.iam.gserviceaccount.com"
}


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

