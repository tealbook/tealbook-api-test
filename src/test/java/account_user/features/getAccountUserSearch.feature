@accounts
Feature: search users using account service

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken
    * def createUserCall = call read('postUser.feature@postUser')
    * def userId = createUserCall.user_id
    * def email = createUserCall.user_email
    * def firstName = createUserCall.firstName
    * def lastName = createUserCall.lastName
    * def enabled = createUserCall.enabled
    * def orgId = createUserCall.org_id
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: search user 200 status code
    Given path '/accounts/user/search'
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
  Scenario Outline: search user 200 status code
    Given path '/accounts/user/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def ids = get response.data[*].id
    * def firstNames = get response.data[*].firstName
    * def lastNames = get response.data[*].lastName
    * def emails = get response.data[*].email
    * def enabledStatuses = get response.data[*].enabled
    * def orgIds = get response.data[*].orgId
    * def results = ('<key>'=='id')? ids:('<key>'=='firstName')? firstNames: ('<key>'=='email')? emails: ('<key>'=='enabled')? enabledStatuses: ('<key>'=='orgId')? orgIds: lastNames
    And print results

    Examples:
      | key       | value                    |
      | id        | karate.setup().userId    |
      | firstName | karate.setup().firstName |
      | lastName  | karate.setup().lastName  |
      | email     | karate.setup().email     |
      | enabled   | karate.setup().enabled   |
      | orgId     | karate.setup().orgId     |



## after view user permit is taken out for the below 3 users
#  Scenario Outline: GET org 403 status code
#    Given path '/accounts/user/search'
#    And header Authorization = <token>
#    When method GET
#    Then status 403
#    And print 'Response Body -> ',response
#    And assert response.message == 'Forbidden resource'
#    Examples:
#      | token                   |
#      | karate.setup().csmToken |
#      | karate.setup().cdaToken |
#      | karate.setup().dqToken  |

  @regression @smoke
  Scenario Outline: search user 400 status code
    Given path '/accounts/user/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'
    Examples:
      | key     | value |
      | id      | 1234  |
      | enabled | 1234  |

  @regression @smoke
  Scenario Outline: search user 200 status code but empty response
    Given path '/accounts/user/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.total == 0
    Examples:
      | key       | value                     |
      | id        | karate.setup().randomUuid |
      | firstName | 1234                      |
      | lastName  | 1234                      |
      | email     | '1234@gmail.com'          |
      | orgId     | karate.setup().randomUuid |


  @regression @smoke
  Scenario Outline: get user details 401
    Given path '/accounts/user/search'
    * param id = 1234
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |

