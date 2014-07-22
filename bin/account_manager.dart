part of gcanvas.server;

abstract class OAuth2Handler {
  OAuth2Handler();

  factory OAuth2Handler.create(
      String client_id,
      String client_secret,
      String client_name,
      String redirect_url,
      String access_token_url,
      String authorise_url,
      String base_url) {
    return new OAuth2NationBulder(
        client_id,
        client_secret,
        client_name,
        redirect_url,
        access_token_url,
        authorise_url,
        base_url);
  }

  Uri get_authorisation_url();
  Future<Map> get_tokens(Map parameters);
}


class OAuth2NationBulder extends OAuth2Handler {
  String client_id;
  String client_secret;
  String client_name;
  String redirect_url;
  String access_token_url;
  String authorise_url;
  String base_url;

  oauth2.AuthorizationCodeGrant _grant;


  OAuth2NationBulder(
      this.client_id,
      this.client_secret,
      this.client_name,
      this.redirect_url,
      this.access_token_url,
      this.authorise_url,
      this.base_url) {
    var authorizationEndpoint = Uri.parse(authorise_url);
    var tokenEndpoint = Uri.parse(access_token_url);


    _grant = new oauth2.AuthorizationCodeGrant(
          client_id, client_secret, authorizationEndpoint, tokenEndpoint);
  }

  Uri get_authorisation_url() => _grant.getAuthorizationUrl(Uri.parse(redirect_url));


  Future<Map> get_tokens(Map parameters) {
    Completer<Map> completer = new Completer<Map>();
    _grant.handleAuthorizationResponse(parameters).then((client) {
      completer.complete(JSON.decode(client.credentials.toJson()));
    });

    return completer.future;
  }
}