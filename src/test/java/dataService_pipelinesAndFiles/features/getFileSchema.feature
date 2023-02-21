Feature: Files - GET files schema

  Background:
    * url baseURL


  @regression @smoke
  Scenario: get files schema detail
    Given path '/data/files/schema'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response


  @regression @smoke
  Scenario Outline: get files schema details 401
    Given path '/data/files/schema'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
