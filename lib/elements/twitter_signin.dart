import 'package:polymer/polymer.dart';

import 'dart:html' show window, Event;

@CustomTag('twitter-signin')
class TwitterSigninElement extends PolymerElement {
  TwitterSigninElement.created() : super.created();

  twitterSignin(Event e) {
    window.location.href = '/twitter';
  }
}