@accounts
Feature: get org using account service

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
  Scenario Outline: get org 200 status code
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def Id = createOrgCall.org_id
    * def name = createOrgCall.name
    Given path '/accounts/org'
    * path Id
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.name == name
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |

## after view user permit is taken out for the below 3 users
#  Scenario Outline: GET org 403 status code
#    * def createOrgCall = call read('postOrg.feature@postOrg')
#    * def Id = createOrgCall.org_id
#    Given path '/accounts/org'
#    * path Id
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
  Scenario: GET org details 400
    Given path '/accounts/org'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'

  @regression @smoke
  Scenario: get org id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/accounts/org'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.message contains 'Could not find any entity of type'

  @regression @smoke
  Scenario Outline: get org details 401
    Given path '/accounts/org'
    * path '12345'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |

