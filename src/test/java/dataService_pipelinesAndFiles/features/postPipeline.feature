Feature: pipelines - POST pipeline

  Background:
    * url baseURL
    * def postPipelineRequestBody = read('../requests/postPipeline.json')
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileName = createFileCall.file_name


  @regression @smoke @postPipeline
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
    And assert response.description=='Input failed validation.'
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




