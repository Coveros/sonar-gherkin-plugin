# Noncompliant [[sc=1;ec=7]] {{Rename this tag to match the regular expression: ^[a-z][-a-z0-9]*$}}
@myTag @my-tag
Feature: My feature Tag Name KO
  Blabla...

  # Noncompliant [[sc=3;ec=10]] {{Rename this tag to match the regular expression: ^[a-z][-a-z0-9]*$}}
  @myTag0
  Scenario: Scenario 1 - Tag Name KO
    Given Blabla given...
    When Blabla when...
    Then Blabla then...

  Scenario: Scenario 2 - Tag Name KO
    Given Blabla given...
    When Blabla when...
    Then Blabla then...
