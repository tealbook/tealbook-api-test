@data @m2
Feature: pipelines - GET pipeline

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: get pipeline id detail
    * def createPipelineCall = call read('postPipeline.feature@postPipeline')
    * def pipelineId = createPipelineCall.pipeline_id
    Given path '/data/pipelines'
    * path pipelineId
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
  Scenario: get pipeline id detail 404
    Given path '/data/pipelines'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario: get pipeline id detail 400
    Given path '/data/pipelines'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'

  @regression @smoke
  Scenario Outline: get pipeline details 401
    * def createPipelineCall = call read('postPipeline.feature@postPipeline')
    * def pipelineId = createPipelineCall.pipeline_id
    Given path '/data/pipelines'
    * path pipelineId
    And header Authorization = '<key>'
    When method GET
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |
