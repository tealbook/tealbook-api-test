@accounts
Feature: post user using account service

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

  @postUser
  Scenario: post user 201
    Given path '/accounts/user'
    And header Authorization = tealbookAdminToken
    When request postUserRequestBody
    * set postUserRequestBody.firstName = randomFirstName
    * set postUserRequestBody.lastName = randomLastName
    * set postUserRequestBody.email = randomEmail
    And print 'Request Body -> ',postUserRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    * def user_id = response.id
    * def user_email = response.email
    * def firstName = response.firstName
    * def lastName = response.lastName
    * def enabled = response.enabled
    * def org_id = response.orgId




  @regression @smoke
  Scenario Outline: post user 201 status code
    Given path '/accounts/user'
    And header Authorization = <token>
    When request postUserRequestBody
    * set postUserRequestBody.firstName = randomFirstName
    * set postUserRequestBody.lastName = randomLastName
    * set postUserRequestBody.email = randomEmail
    And print 'Request Body -> ',postUserRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    And assert response.email == randomEmail
    And assert response.firstName == randomFirstName
    And assert response.lastName == randomLastName
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |


  Scenario Outline: post user 403 status code
    Given path '/accounts/user'
    And header Authorization = <token>
    When request postUserRequestBody
    And print 'Request Body -> ',postUserRequestBody
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
    Given path '/accounts/user'
    And header Authorization = tealbookAdminToken
    When request postUserRequestBody
    * set postUserRequestBody.email = randomEmail
    * remove postUserRequestBody $.<key>
    And print 'Request Body -> ',postUserRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'null value'
    Examples:
      | key       |
      | firstName |
      | lastName  |
      | email     |


  @regression @smoke
  Scenario Outline: post user details 401
    Given path '/accounts/user'
    And header Authorization = '<key>'
    When request postUserRequestBody
    And print 'Request Body -> ',postUserRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |


