@accounts
Feature: search permission groups using account service

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken
    * def createUserCall = call read('postUsers.feature@postUser')
    * def userId = createUserCall.user_id
    * def randomGroups = Java.type('utils.GenerateRandomVariables').randomPermissionGroups()
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: search user 200 status code
    Given path '/accounts/permission-group/search'
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

  @getPermissionId
  Scenario: search user 200 status code
    Given path '/accounts/permission-group/search'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def permission_id = response.data[0].id
    * def permission_name = response.data[0].displayName


#  @regression @smoke
#  Scenario Outline: search user 403 status code
#    Given path '/accounts/permission-group/search'
#    And header Authorization = <token>
#    When method GET
#    Then status 200
#    And print 'Response Body -> ',response
#    Examples:
#      | token                       |
#      | karate.setup().csmToken     |
#      | karate.setup().cdaToken     |
#      | karate.setup().dqToken      |


  @regression @smoke
  Scenario Outline: search permission group 200 status code
    Given path '/accounts/permission-group/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def ids = get response.data[*].id
    * def names = get response.data[*].displayName
    * def results = ('<key>'=='userId')? ids: names
    And print results

    Examples:
      | key    | value                       |
      | userId | karate.setup().userId       |
      | name   | karate.setup().randomGroups |


  @regression @smoke
  Scenario Outline: search user 400 status code
    Given path '/accounts/permission-group/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'
    Examples:
      | key    | value |
      | userId | 1234  |


  @regression @smoke
  Scenario Outline: search user 200 status code with empty response
    Given path '/accounts/permission-group/search'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.total == 0
    Examples:
      | key    | value                     |
      | userId | karate.setup().randomUuid |
      | name   | 'helloWorld'              |


  @regression @smoke
  Scenario Outline: get user details 401
    Given path '/accounts/permission-group/search'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |

