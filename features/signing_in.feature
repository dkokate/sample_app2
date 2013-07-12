Feature: Signing in

Scenario: Unsuccessful signin
Given a User visits the signin page
When he submits invalid signin information
Then he should see an error message

Scenario: Successful sigin
Given a user visits the sigin page
And the user has an account
When the user submits valid sigin information
Then he should see his profile page
And he should see a signout link