Feature: Files - GET files schema

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: get files schema detail
    Given path '/data/files/schema'
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |


  @regression @smoke
  Scenario Outline: get files schema details 401
    Given path '/data/files/schema'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |
