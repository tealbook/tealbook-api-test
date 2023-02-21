Feature: pipelines - GET pipelines

  Background:
    * url baseURL


  @regression @smoke
  Scenario Outline: get pipelines details
    Given path '/data/pipelines'
    And header Authorization = tealbookAdminToken
    * def query = {scope:'all', status:'<key>',org_id : '<string>'}
    And params query
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def statuses = $responses[*].status
    And print statuses
    And match each statuses == '<key>'
    Examples:
      | key      |
      | running  |
      | stopped  |
      | pending  |
      | failed   |
      | finished |


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
      | key          | response                   |
      | ksjd         | no bearer token in request |











