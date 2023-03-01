@accounts
Feature: put user using account service

  Background:
    * url baseURL
    * def postUserRequestBody = read('../requests/postUser.json')
    * def randomFirstName = Java.type('utils.GenerateRandomVariables').randomFirstName()
    * def randomLastName = Java.type('utils.GenerateRandomVariables').randomLastName()
    * def randomEmail = Java.type('utils.GenerateRandomVariables').randomEmail()

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: put user 200 status code
    Given path '/accounts/user'
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    * def email = createUserCall.user_email
    * path id
    And header Authorization = <token>
    When request postUserRequestBody
    * set postUserRequestBody.firstName = randomFirstName
    * set postUserRequestBody.lastName = randomLastName
    * set postUserRequestBody.email = randomEmail
    * remove postUserRequestBody $.orgId
    * remove postUserRequestBody $.permissions
    And print 'Request Body -> ',postUserRequestBody
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    And assert response.firstName == randomFirstName
    And assert response.lastName == randomLastName
    And match response.email == email
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |


  Scenario Outline: put user 403 status code
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id
    And header Authorization = <token>
    When request postUserRequestBody
    And print 'Request Body -> ',postUserRequestBody
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
  Scenario: put user details 400
    Given path '/accounts/user'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When request postUserRequestBody
    And print 'Request Body -> ',postUserRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'

  @regression @smoke
  Scenario: put user  400
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.message=='Input failed validation.'

  @regression @smoke
  Scenario: put user id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/accounts/user'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When request postUserRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.message contains 'Could not find any entity of type'


  @regression @smoke
  Scenario Outline: put user details 401
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id
    And header Authorization = '<key>'
    When request postUserRequestBody
    And print 'Request Body -> ',postUserRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |


