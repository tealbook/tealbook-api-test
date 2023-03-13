@accounts
Feature: post org using account service

  Background:
    * url baseURL
    * def postOrgRequestBody = read('../requests/postOrg.json')
    * def randomCompanyName = Java.type('utils.GenerateRandomVariables').randomName()

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @postOrg
  Scenario: post org
    Given path '/accounts/org'
    And header Authorization = tealbookAdminToken
    When request postOrgRequestBody
    * set postOrgRequestBody.name = randomCompanyName
    And print 'Request Body -> ',postOrgRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    * def org_id = response.id
    * def name = response.name
    * def orgTypes = response.orgTypes

  @regression @smoke
  Scenario Outline: post org 201 status code
    Given path '/accounts/org'
    And header Authorization = <token>
    When request postOrgRequestBody
    * set postOrgRequestBody.name = randomCompanyName
    And print 'Request Body -> ',postOrgRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    And assert response.name == randomCompanyName
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |


  Scenario Outline: post org 403 status code
    Given path '/accounts/org'
    And header Authorization = <token>
    When request postOrgRequestBody
    And print 'Request Body -> ',postOrgRequestBody
    When method POST
    Then status 403
    And print 'Response Body -> ',response
    And assert response.message == 'Forbidden resource'
    Examples:
      | token                   |
      | karate.setup().csmToken |
      | karate.setup().cdaToken |
      | karate.setup().dqToken  |

  @regression @smoke
  Scenario Outline: post user details 400
    Given path '/accounts/org'
    And header Authorization = tealbookAdminToken
    When request postOrgRequestBody
    * set postOrgRequestBody.name = randomCompanyName
    * remove postOrgRequestBody $.<key>
    And print 'Request Body -> ',postOrgRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'null value'
    Examples:
      | key      |
      | name     |
      | orgTypes |


  @regression @smoke
  Scenario Outline: post org details 401
    Given path '/accounts/org'
    And header Authorization = '<key>'
    When request postOrgRequestBody
    And print 'Request Body -> ',postOrgRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |


