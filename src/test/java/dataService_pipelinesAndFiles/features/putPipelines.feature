@data
Feature: put pipelines using account service

  Background:
    * url baseURL
    * def postPipelinesRequestBody = read('../requests/postPipeline.json')

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @regression @smoke
  Scenario Outline: put pipelines 200 status code
    Given path '/data/pipelines'
    * def createPipelinesCall = call read('postPipeline.feature@postPipeline')
    * def id = createPipelinesCall.pipeline_id
    * def batch_id = createPipelinesCall.batch_id
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileName = createFileCall.file_name
    * path id
    And header Authorization = <token>
    When request postPipelinesRequestBody
    * remove postPipelinesRequestBody.pipeline_name
    * set postPipelinesRequestBody.source.file_name = fileName
    And print 'Request Body -> ',postPipelinesRequestBody
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    And match response.inputs[*].batch_id contains batch_id
    And assert response.status == 'queued'
    Examples:
      | token                     |
      | karate.setup().adminToken |
      | karate.setup().cdaToken   |
      | karate.setup().dqToken    |


  Scenario Outline: put pipelines 403 status code
    * def createPipelinesCall = call read('postPipeline.feature@postPipeline')
    * def id = createPipelinesCall.pipeline_id
    Given path '/data/pipelines'
    * path id
    And header Authorization = <token>
    * remove postPipelinesRequestBody.pipeline_name
    * remove postPipelinesRequestBody.source
    When request postPipelinesRequestBody
    And print 'Request Body -> ',postPipelinesRequestBody
    When method PUT
    Then status 403
    And print 'Response Body -> ',response
    And assert response.message == 'Forbidden resource'
    Examples:
      | token                       |
      | karate.setup().csmToken     |
      | karate.setup().supportToken |

  @regression @smoke
  Scenario: put pipelines details 400
    Given path '/data/pipelines'
    * path '12345'
    And header Authorization = tealbookAdminToken
    * remove postPipelinesRequestBody.pipeline_name
    When request postPipelinesRequestBody
    And print 'Request Body -> ',postPipelinesRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And match response.description contains 'not a valid'

  @regression @smoke
  Scenario: put pipelines  400
    * def createPipelinesCall = call read('postPipeline.feature@postPipeline')
    * def id = createPipelinesCall.pipeline_id
    Given path '/data/pipelines'
    * path id
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: put pipelines id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/data/pipelines'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    * remove postPipelinesRequestBody.pipeline_name
    When request postPipelinesRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'Record not found'


  @regression @smoke
  Scenario Outline: put pipelines details 401
    * def createPipelinesCall = call read('postPipeline.feature@postPipeline')
    * def id = createPipelinesCall.pipeline_id
    Given path '/data/pipelines'
    * path id
    And header Authorization = '<key>'
    * remove postPipelinesRequestBody.pipeline_name
    When request postPipelinesRequestBody
    And print 'Request Body -> ',postPipelinesRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.message=='<response>'
    Examples:
      | key  | response     |
      | ksjd | no bearer token in request |


