//import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';

import 'package:msal_js/msal_js.dart';
import '/common/config.dart' as config;
import 'auth_manager_interface.dart';


AuthManager getManager() => AuthManagerWeb();

class AuthManagerWeb extends AuthManager {
  //static AccountInfo? _accountInfo;

  static final PublicClientApplication publicClientApplication = init();

  static init(){

    print("AuthManagerWeb init() start...");
    PublicClientApplication initPublicClientApplication = PublicClientApplication(
      Configuration()
        ..auth = (BrowserAuthOptions()
          ..clientId = config.authWebClientId
          ..authority = config.authWebAuthority)
        ..system = (BrowserSystemOptions()
          ..loggerOptions = (LoggerOptions()
            ..loggerCallback = (LogLevel logLevel, String message, bool containsPii){
              print("AuthManagerWeb.init(): containsPii = $containsPii");
              if(containsPii){
                return;
              }
              print("AuthManagerWeb.init(): [$logLevel] $message");
            }
            ..logLevel = LogLevel.verbose
          )
        ),

    );

    print("AuthManagerWeb.init(): publicClientApplication.hashCode = ${initPublicClientApplication.hashCode}");

    return initPublicClientApplication;
  }


  @override
  Future<String?> getAccessToken({BuildContext? context, bool silent = true}) async {
    if(publicClientApplication.getAllAccounts().isEmpty){
      print("AuthManagerWeb.getAccessToken(): No accounts available");
      //TODO: Add error message shield
      return null;
    }

    try{
      final silentRequest = SilentRequest()..scopes = config.authWebScope;

      final AuthenticationResult silentResult = await publicClientApplication.acquireTokenSilent(silentRequest);

      final silentRequestCustomApi = SilentRequest()..scopes = [ "api://92ebb507-4d16-40c8-b52e-85f0f2086cbf/settings.save.user" ];

      final AuthenticationResult customApiToken = await publicClientApplication.acquireTokenSilent(silentRequestCustomApi);

      publicClientApplication.setActiveAccount(silentResult.account);

      print("A555: silent accessToken:${silentResult.accessToken}");
      print("A555: silent customApiToken:${customApiToken.accessToken}");


      return silentResult.accessToken;
    } on InteractionRequiredAuthException{
      try{
        final interactiveRequest = PopupRequest()..scopes = config.authWebScope;

        final AuthenticationResult interactiveResult =
        await publicClientApplication.acquireTokenPopup(interactiveRequest);

        publicClientApplication.setActiveAccount(interactiveResult.account);

        //TODO: Give message that accessToken just refreshed.
        print("A555: interactive accessToken:${interactiveResult.accessToken}");
        return interactiveResult.accessToken;
      } on AuthException catch (exception){
        print("AuthManagerWeb.getAccessToken(): interactive exception = $exception");
        //TODO: Give message about authorization interactive exception
        return null;
      }
    } on AuthException catch (exception){
      print("AuthManagerWeb.getAccessToken(): silent exception = $exception");
      //TODO: Give message about authorization silent exception
      return null;
    }

  }

  @override
  Future<String?> getActiveAccount() async {
    return publicClientApplication.getActiveAccount()?.username;
  }

  @override
  Future<bool> isLoggedIn() async {
    return await getAccessToken() != null ? true : false;
  }

  @override
  Future<String?> login({BuildContext? context}) async {
    try{
      final AuthenticationResult? redirectResult =
      await publicClientApplication.handleRedirectFuture();

      if(redirectResult != null){
        publicClientApplication.setActiveAccount(redirectResult.account);
        //TODO: Give message about login successful

        return redirectResult.accessToken;
      } else {
        final List<AccountInfo> accounts = publicClientApplication.getAllAccounts();

        if(accounts.isNotEmpty){
          publicClientApplication.setActiveAccount(accounts.first);

          final accessToken = await getAccessToken();

          if(accessToken!=null){
            //TODO Give warning what account is active
          }
          else{
            throw Exception("Could not achieve valid accessToken (null)");
          }

          return accessToken;

        }
      }

    } on AuthException catch (exception){
      throw Exception("Login failed ${exception.message}");
    } on Exception catch(_){
      throw Exception("Unknown error occurred during login");
    }

    try{
      final authenticationResult = await publicClientApplication.loginPopup(
          PopupRequest()..scopes = config.authWebScope);
      //_accountInfo = response.account;

      publicClientApplication.setActiveAccount(authenticationResult.account);

      if(context!=null){
        //TODO: Give message login successful
      }

      return authenticationResult.accessToken;
    } on AuthException catch(exception){
      throw Exception("Login failed: ${exception.message}");
    }

  }

  @override
  Future<void> logout() async {
    publicClientApplication.logoutRedirect();
  }
}