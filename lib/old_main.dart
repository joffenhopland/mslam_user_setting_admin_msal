/*import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mslam_user_setting_admin/post_model.dart';
import 'package:msal_js/msal_js.dart';



Future<void> main() async {
  // Configure and create an MSAL PublicClientApplication
  final config = Configuration()
    ..auth = (BrowserAuthOptions()..clientId = clientId);

  final publicClientApp = PublicClientApplication(config);

  // Handle redirect flow (optional)
  try {
    final AuthenticationResult? redirectResult =
        await publicClientApp.handleRedirectFuture();

    if (redirectResult != null) {
      // Successful redirect login, redirectResult contains
      // the authentication account and authorized tokens
      print('Redirect login successful. name: ${redirectResult.account!.name}');
    } else {
      // Normal page load, did not just come back from an
      // auth redirect
      // Check if an account is logged in
      final List<AccountInfo> accounts = publicClientApp.getAllAccounts();

      if (accounts.isNotEmpty) {
        publicClientApp.setActiveAccount(accounts.first);
      }
    }
  } on AuthException catch (ex) {
    // Redirect auth failed, ex contains the details of
    // why auth failed
    print('MSAL: ${ex.message}');
  }
  // Run the Flutter app
  runApp(MyApp(publicClientApp: publicClientApp));
  }

  void _loggerCallback(LogLevel level, String message, bool containsPii) {
  if (containsPii) {
    return;
  }
  print('MSAL: [$level] $message');
  }

  // Get all users from API
Future<List<Post>> fetchPost() async {
  const String api = 'http://127.0.0.1:5000/users';
  final response = await http.get(Uri.parse(api));
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');

  if (response.statusCode == 200) {
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Post>((json) => Post.fromMap(json)).toList();
  } else {
    throw Exception('Failed to load API');
  }
}


/// Flutter app.
///
/// Passes the [PublicClientApplication] onto the home page.
class MyApp extends StatefulWidget {
  final PublicClientApplication publicClientApp;

  const MyApp({required this.publicClientApp});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MSlam User Settings Admin',
        theme: ThemeData(
          primaryColor: Colors.lightBlueAccent,
        ),
        home:MyHomePage(publicClientApp: publicClientApp)
    );
  }
}

/// The demo home page for interacting with the MSAL [PublicClientApplication].
class MyHomePage extends StatefulWidget {
  final PublicClientApplication publicClientApp;

  const MyHomePage({
    required this.publicClientApp,
    Key? key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Post>> futurePost;
  AccountInfo? _account;

  @override
  void initState() {
    super.initState();
    futurePost = fetchPost();
    // Get the currently active account, if any
    _account = widget.publicClientApp.getActiveAccount();
  }

  /// Starts a redirect login.
  void _loginRedirect() {
    widget.publicClientApp.loginRedirect(RedirectRequest()..scopes = scopes);
  }

  /// Sarts a popup login.
  Future<void> _loginPopup() async {
    try {
      final respone = await widget.publicClientApp.loginPopup(PopupRequest()..scopes = scopes);
      setState(() {
        _account = respone.account;
      });
      print('Popup login successful. name: ${_account!.name}');
    } on AuthException catch (ex) {
      print('MSAL: ${ex.errorCode}:${ex.errorMessage}');
    }
  }

  /// Logs the current account out using a redirect.
  void _logoutRedirect() {
    widget.publicClientApp.logoutRedirect();
  }

  /// Logs the current account out using a popup.
  Future<void> _logoutPopup() async {
    await widget.publicClientApp.logoutPopup();

    setState(() {
      _account = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MSlam User Settings Admin'),
        ),
        body: FutureBuilder<List<Post>>(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: (Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data![index].userEmail}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("${snapshot.data![index].deviceType}"),
                      ],
                    )),
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      );
  }
}
*/