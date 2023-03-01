@accounts
Feature: view available permissions using account service


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
  Scenario Outline: view available permissions 200 status code
    Given path 'accounts/permission-group/available-permissions'
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def permissions = ["User Management","Clients","Pipelines"]
    * def permissionGroupNames = get response.globalAdmin[*].name
    And match permissionGroupNames deep contains permissions
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |

#  @regression @smoke
#  Scenario Outline: view available permissions 403 status code
#    Given path 'accounts/permission-group/available-permissions'
#    And header Authorization = <token>
#    When method GET
#    Then status 403
#    And print 'Response Body -> ',response
#    And assert response.message == 'Forbidden resource'
#    Examples:
#      | token                       |
#      | karate.setup().csmToken     |
#      | karate.setup().cdaToken     |
#      | karate.setup().dqToken      |

