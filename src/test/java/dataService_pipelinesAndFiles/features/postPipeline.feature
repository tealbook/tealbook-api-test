@data @m2
Feature: pipelines - POST pipeline

  Background:
    * url baseURL
    * def postPipelineRequestBody = read('../requests/postPipeline.json')
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileName = createFileCall.fileName

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @postPipeline
  Scenario: post pipeline
    Given path '/data/pipelines'
    And header Authorization = tealbookAdminToken
    When request postPipelineRequestBody
    * set postPipelineRequestBody.source.file_name = fileName
    And print 'Request Body -> ',postPipelineRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def pipeline_id = response.pipeline_id
    * def batch_id = response.inputs[0].batch_id
    * def file_name = response.inputs[0].file_name
    * print batch_id

  @regression @smoke
  Scenario Outline: post pipeline using authorized user
    Given path '/data/pipelines'
    And header Authorization = <token>
    When request postPipelineRequestBody
    * set postPipelineRequestBody.source.file_name = fileName
    And print 'Request Body -> ',postPipelineRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    And assert response.status == 'queued'
    And assert response.pipeline_type == 'client_data_vendor'
    Examples:
      | token                     |
      | karate.setup().adminToken |
      | karate.setup().cdaToken   |
      | karate.setup().dqToken    |

  @regression @smoke
  Scenario Outline: post pipeline 403
    Given path '/data/pipelines'
    And header Authorization = <token>
    When request postPipelineRequestBody
    * set postPipelineRequestBody.source.file_name = fileName
    And print 'Request Body -> ',postPipelineRequestBody
    When method POST
    Then status 403
    And print 'Response Body -> ',response
    And match response.description contains 'Forbidden'
    Examples:
      | token                       |
      | karate.setup().csmToken     |
      | karate.setup().supportToken |

  @regression @smoke
  Scenario Outline: post pipeline details 400
    Given path '/data/pipelines'
    And header Authorization = tealbookAdminToken
    When request postPipelineRequestBody
    * remove postPipelineRequestBody $.<key>
    And print 'Request Body -> ',postPipelineRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And match response.description contains 'Invalid input'
    Examples:
      | key              |
      | pipeline_type    |
      | pipeline_name    |
      | source           |
      | source.file_name |

  @regression @smoke
  Scenario Outline: post pipeline details 401
    Given path '/data/pipelines'
    And header Authorization = '<key>'
    When request postPipelineRequestBody
    And print 'Request Body -> ',postPipelineRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |




