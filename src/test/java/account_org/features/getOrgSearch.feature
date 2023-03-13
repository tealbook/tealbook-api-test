@accounts
Feature: search org using account service

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
  Scenario Outline: search org 200 status code
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def Id = createOrgCall.org_id
    Given path '/accounts/org/search'
    And param id  = Id
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def orgIds = get response.data[*].id
    And print orgIds
    And match orgIds contains Id
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |

  @regression @smoke
  Scenario Outline: search org 200 status code
    * def createOrgCall = call read('postOrg.feature@postOrg')
    * def Id = createOrgCall.org_id
    * def orgTypes = createOrgCall.orgTypes
    Given path '/accounts/org/search'
    And param id  = Id
    And param orgType = orgTypes
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def orgIds = get response.data[*].id
    * def org_types = get response.data[*].orgTypes[*]
    And print orgIds
    And print org_types
    And match each orgIds == Id
    And match org_types deep contains orgTypes
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |


  @regression @smoke
  Scenario Outline: search org 200 status code
    Given path '/accounts/org/search'
    * def randomOrg = Java.type('utils.GenerateRandomVariables').randomOrgType()
    And param orgType  = randomOrg
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def orgTypes = get response.data[*].orgTypes[*]
    And print orgTypes
    And match orgTypes contains randomOrg
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |


## after view user permit is taken out for the below 3 users
#  Scenario Outline: GET org 403 status code
#    Given path '/accounts/org/search'
#    * def randomOrg = Java.type('utils.GenerateRandomVariables').randomOrgType()
#    And param orgType  = randomOrg
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
    Given path '/accounts/org/search'
    * param id = 1234
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'invalid input syntax'

  @regression @smoke
  Scenario: GET org details 200 with empty response when sending invalid org type
    Given path '/accounts/org/search'
    * param orgType = 1234
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.total == 0

  @regression @smoke
  Scenario: GET org details 200 with empty response when sending invalid org id
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/accounts/org/search'
    * param id = randomUuid
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.total == 0


  @regression @smoke
  Scenario Outline: get org details 401
    Given path '/accounts/org/search'
    * param id = 1234
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | Unauthorized |

