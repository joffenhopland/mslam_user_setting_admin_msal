
const String authTenant = "294c7ede-2387-42ab-bbff-e5eb67ca3aee";
const String authClientId = "ec7f8c91-32ed-48c2-90f0-a15cded40bc4";
const List<String> authScopeList = ['openid','profile','offline_access'];
const String authScope = "openid profile offline_access";
const String authRedirectUri = 'https://login.live.com/oauth20_desktop.srf';
const String authAuthorityPrefix = 'https://login.microsoftonline.com/';




const String authWebClientId = authClientId;
const String authWebAuthority = "$authAuthorityPrefix$authTenant";
const List<String> authWebScope = authScopeList;