Feature: Files - GET file

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get file id detail
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileId = createFileCall.file_id
    * def orgId = createFileCall.org_id
    Given path '/data/files'
    * path fileId + '/url'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And assert response.organization_id == orgId

  @regression @smoke
  Scenario: get file by id detail 400
    Given path '/data/files'
    * path '12345/url'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: get file id detail 404
    Given path '/data/files'
    * path randomUuid + '/url'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: get file by id details 401
    * def createFileCall = call read('uploadFile.feature@postFile')
    * def fileId = createFileCall.file_id
    Given path '/data/files'
    * path fileId + '/url'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |