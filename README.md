gcanvas
=======

Dart (web app) version of gCanvas

This now consists of the client, web app and the dart server code to support it.

This has been set up to run on Heroku using PostgreSQL DB.


Was going to have users install into their Nation, but it turns out most Nation
Users can't do that.  Also API calls have global permissions.

@TODO: Make them register using an email address and name as an identifier.
@TODO: Have them verify they own the email by sending email to them and getting them to click on the link provided in the email.
@TODO: Use the API to search for the User by email address and confirm the name they provided matches the one on NationBuilder
@TODO: Check for NationBuilder Point person rights, and allow them to access a list of volunteers stored on NationBuilder
@TODO: Keep track of what that volunteer list id is, so we can reference it in the future
@TODO: Allow the point person to create a list of addresses to doorknock and assign that to one of the people in the list of volunteers (repeat and rinse)
@TODO: Allow volunteer to download that list assigned to them and update it on NationBuilder once they are finished.
