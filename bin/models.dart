part of gcanvas.server;


@Kind()
class DoorKnocker extends Entity {
  @constructKind
  DoorKnocker(Key key): super(key);

  @Property(indexed: true)
  String get email => getProperty('email');
  void set email(String val) => setProperty('email', val);

  @Property(indexed: false)
  String get password => getProperty('password');
  void set password(String val) => setProperty('password', val);

  @Property(indexed: false)
  String get salt => getProperty('salt');
  void set salt(String val) => setProperty('salt', val);

  @Property(indexed: false)
  String get firstname => getProperty('firstname');
  void set firstname(String val) => setProperty('firstname', val);

  @Property(indexed: false)
  String get lastname => getProperty('lastname');
  void set lastname(String val) => setProperty('lastname', val);

  @Property(indexed: false)
  String get pointPerson => getProperty('pointPerson');
  void set pointPerson(String val) => setProperty('pointPerson', val);

  @Property(indexed: false)
  bool get confirmed => getProperty('confirmed');
  void set confirmed(bool val) => setProperty('confirmed', val);
}


@Kind()
class OAuth2Credentials extends Entity {
  @constructKind
  OAuth2Credentials(Key key) : super(key);

  @Property(indexed: false)
  String get client_name => getProperty('client_name');
  void set client_name(String val) => setProperty('client_name', val);

  @Property(indexed: false)
  String get client_id => getProperty('client_id');
  void set client_id(String val) => setProperty('client_id', val);

  @Property(indexed: false)
  String get client_secret => getProperty('client_secret');
  void set client_secret(String val) => setProperty('client_secret', val);

  @Property(indexed: false)
  String get access_token => getProperty('access_token');
  void set access_token(String val) => setProperty('access_token', val);

  @Property(indexed: false)
  String get refresh_token => getProperty('refresh_token');
  void set refresh_token(String val) => setProperty('refresh_token', val);

  @Property(indexed: false)
  String get redirect_url => getProperty('redirect_url');
  void set redirect_url(String val) => setProperty('redirect_url', val);

  @Property(indexed: false)
  String get access_token_url => getProperty('access_url_token');
  void set access_token_url(String val) => setProperty('access_token_url', val);

  @Property(indexed: false)
  String get authorise_url => getProperty('authorise_url');
  void set authorise_url(String val) => setProperty('authorise_url', val);

  @Property(indexed: false)
  String get base_url => getProperty('base_url');
  void set base_url(String val) => setProperty('base_url', val);

  @Property(indexed: false)
  String get expiry => getProperty('expiry');
  void set expiry(String val) => setProperty('expiry', val);
}