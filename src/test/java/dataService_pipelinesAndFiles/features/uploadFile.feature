Feature: files - POST files

  Background:
    * url baseURL

  @regression @smoke @postFile
  Scenario: post file
    Given path '/data/files/upload'
    And header Authorization = tealbookAdminToken
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers11.csv',contentType:'text/csv'}
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    * def file_name = response.file_name
    * def org_id = response.organization_id
    * def file_id = response.file_storage_id


  @regression @smoke
  Scenario: post file details 400
    Given path '/data/files/upload'
    And header Authorization = tealbookAdminToken
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers11.csv',contentType:'img/csv'}
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario Outline: post file details 401
    Given path '/data/files/upload'
    And header Authorization = '<key>'
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers11.csv',contentType:'text/csv'}
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |




