Feature: Files - GET files

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
  Scenario Outline: get files detail 200
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileId = createFileCall.file_id
    * def orgId = createFileCall.org_id
    Given path '/data/files'
    And header Authorization = <token>
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def orgIds = $responses[*].organization_id
    * def fileIds = $responses[*].file_storage_id
    And print orgIds
    And print fileIds
    And match each orgIds == orgId
    And match fileIds contains fileId
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |


  @regression @smoke
  Scenario Outline: get files details 401
    Given path '/data/files'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |
