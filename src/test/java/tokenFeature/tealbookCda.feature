Feature: obtain tealbookCda token

  Background:
    * url baseURL
    * def userId = 'cda@tealbook.com'
    * def passWord = 'Password!1'

  Scenario: Generate cda token
    Given path '/auth/realms/tealbook/protocol/openid-connect/token'
    And form field grant_type = 'password'
    And form field client_id = 'tealbook-public'
    And form field scope = 'openid'
    And form field username = userId
    And form field password = passWord
    When method POST
    Then status 200
    * def token = 'Bearer ' + response.access_token