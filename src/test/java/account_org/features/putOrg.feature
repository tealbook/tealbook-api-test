@accounts
Feature: put org using account service

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

  @regression @smoke
  Scenario Outline: put org 200 status code
    Given path '/accounts/org'
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def id = createOrgCall.org_id
    * def name = createOrgCall.name
    * path id
    And header Authorization = <token>
    * set postOrgRequestBody.name = randomCompanyName
    And print 'Request Body -> ',postOrgRequestBody
    When request postOrgRequestBody
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    And assert response.name == randomCompanyName
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |


  Scenario Outline: put org 403 status code
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def id = createOrgCall.org_id
    Given path '/accounts/org'
    * path id
    And header Authorization = <token>
    When request postOrgRequestBody
    And print 'Request Body -> ',postOrgRequestBody
    When method PUT
    Then status 403
    And print 'Response Body -> ',response
    And assert response.message == 'Forbidden resource'
    Examples:
      | token                   |
      | karate.setup().csmToken |
      | karate.setup().cdaToken |
      | karate.setup().dqToken  |

  @regression @smoke
  Scenario: put org details 400
    Given path '/accounts/org'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When request postOrgRequestBody
    And print 'Request Body -> ',postOrgRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'

  @regression @smoke
  Scenario: put org 400
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def id = createOrgCall.org_id
    Given path '/accounts/org'
    * path id
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.message == 'Input failed validation.'

  @regression @smoke
  Scenario: put org id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/accounts/org'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When request postOrgRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.message contains 'Could not find any entity of type'


  @regression @smoke
  Scenario Outline: put org details 401
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def id = createOrgCall.org_id
    Given path '/accounts/org'
    * path id
    And header Authorization = '<key>'
    When request postOrgRequestBody
    And print 'Request Body -> ',postOrgRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message == '<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |


