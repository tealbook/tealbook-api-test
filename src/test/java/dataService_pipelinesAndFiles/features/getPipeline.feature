Feature: pipelines - GET pipelines

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
  Scenario Outline: get pipelines details functional 200
    Given path '/data/pipelines'
    And header Authorization = tealbookAdminToken
    * def randomDigit = Java.type('utils.GenerateRandomVariables').randomDigit()
    * def query = {scope:'all', status:'<key>',org_id : '<string>', limit: '<limit>'}
    And params query
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response.data[*]
    * def statuses = $responses[*].status
    And print statuses
    And match each statuses == '<key>'
    And assert statuses.length <= <limit>
    Examples:
      | key      | limit |
      | running  | 15    |
      | stopped  | 5     |
      | pending  | 7     |
      | failed   | 8     |
      | finished | 9     |

  @regression @smoke
  Scenario Outline: get pipelines details permission 200
    Given path '/data/pipelines'
    And header Authorization = <token>
    * def randomDigit = Java.type('utils.GenerateRandomVariables').randomDigit()
    * def query = {scope:'all', status:'running',org_id : '<string>', limit: 10}
    And params query
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response.data[*]
    * def statuses = $responses[*].status
    And print statuses
    And match each statuses == 'running'
    And assert statuses.length <= 10
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |


  @regression @smoke
  Scenario: get pipeline details 400
    Given path '/data/pipelines'
    And header Authorization = tealbookAdminToken
    * def query = {scope:'all', status:'all',org_id : '<string>'}
    And params query
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'

  @regression @smoke
  Scenario Outline: get pipeline details 401
    Given path '/data/pipelines'
    And header Authorization = '<key>'
    * def query = {scope:'all', status:'all',org_id : '<string>'}
    And params query
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |











