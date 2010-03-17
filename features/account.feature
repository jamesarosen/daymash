Feature: Accounts
  In order to provide a have personalized experience
  Susan can view and edit her profile
  
  Scenario: view profile
    Given I am signed in as Susan via Facebook
    And I am on the home page
    When I follow "My Profile"
    Then I should see "You can sign in via"
    And I should see "Facebook"
  
  Scenario: edit profile
    Given I am signed in as Susan
    And I am on the home page
    When I follow "My Profile"
    And I follow "Edit"
    And I fill in "user_display_name" with "Suzeee"
    And I press "Make It So"
    Then I should see "Signed in as Suzeee"

  Scenario: can't delete last credential
    Given I am signed in as Susan
    And I am on my profile page
    Then I should not see "delete" within "li.credential"

  Scenario: delete a credential
    Given I am signed in as Susan
    And Susan has registered a credential from Facebook
    And Susan has registered a credential from Twitter
    And I am on my profile page
    And I press "delete" within "li.credential.Facebook"
    Then I should be on my profile page
    And I should see "Deleted Facebook credential"

  Scenario: undo deletion of a credential
    Given I am signed in as Susan
    And Susan has registered a credential from Facebook
    And Susan has registered a credential from Twitter
    And I am on my profile page
    And I press "delete" within "li.credential.Facebook"
    And I press "undo"
    Then I should be on my profile page
    And I should see "delete" within "li.credential.Facebook"
