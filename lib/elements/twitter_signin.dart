@HtmlImport('twitter_signin.html')
library gcanvas.twitter_signin;

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'dart:html' show window, Event;

@PolymerRegister('twitter-signin-button')
class TwitterSigninElement extends PolymerElement {
  TwitterSigninElement.created() : super.created();

  @reflectable
  void twitterSignin([_, __]) {
    window.location.href = '/twitter';
  }
}