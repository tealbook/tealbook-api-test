Feature: obtain tealbookAdmin token

  Background:
    * url baseURL

  Scenario: Generate tealbook admin token
    Given path '/auth/realms/tealbook/protocol/openid-connect/token'
    And form field grant_type = 'password'
    And form field client_id = 'tealbook-public'
    And form field scope = 'openid'
    And form field username = 'qaadmin@tealbook.com'
    And form field password = 'Passw0rd!'
    When method POST
    Then status 200
    * def token = 'Bearer '+response.access_token
