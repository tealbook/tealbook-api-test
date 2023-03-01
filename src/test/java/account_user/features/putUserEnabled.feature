@accounts
Feature: put user enablement using account service

  Background:
    * url baseURL
    * def enabled = Java.type('utils.GenerateRandomVariables').randomTrueFalse()
    * def putUserEnabledRequestBody = read('../requests/putUserEnabled.json')

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: put user enablement 200 status code
    Given path '/accounts/user'
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    * def email = createUserCall.user_email
    * path id + '/enabled'
    And header Authorization = <token>
    When request putUserEnabledRequestBody
    * set putUserEnabledRequestBody.enabled = enabled
    And print 'Request Body -> ',putUserEnabledRequestBody
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
#    And match response.email == email
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |


  Scenario Outline: put user enablement 403 status code
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id
    And header Authorization = <token>
    When request putUserEnabledRequestBody
    And print 'Request Body -> ',putUserEnabledRequestBody
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
  Scenario: put user enablement details 400
    Given path '/accounts/user'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When request putUserEnabledRequestBody
    And print 'Request Body -> ',putUserEnabledRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'

  @regression @smoke
  Scenario: put user  400
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id + '/enabled'
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
    * path randomUuid + '/enabled'
    And header Authorization = tealbookAdminToken
    When request putUserEnabledRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.message contains 'Could not find any entity of type'


  @regression @smoke
  Scenario Outline: put user enablement details 401
    * def createUserCall = call read('postUser.feature@postUser')
    * def id = createUserCall.user_id
    Given path '/accounts/user'
    * path id
    And header Authorization = '<key>'
    When request putUserEnabledRequestBody
    And print 'Request Body -> ',putUserEnabledRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |


