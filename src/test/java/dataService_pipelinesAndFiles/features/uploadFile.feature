@data @m2
Feature: files - POST files

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @postFile
  Scenario: post file
    Given path '/data/files/upload'
    And header Authorization = tealbookAdminToken
    * def fileName = 'Rutgers.csv'
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers.csv',contentType:'text/csv'}
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    * def file_name = response.file_name
    * def org_id = response.organization_id
    * def file_id = response.file_storage_id


  @regression @smoke
  Scenario Outline: post file 200
    Given path '/data/files/upload'
    And header Authorization = <token>
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers11.csv',contentType:'text/csv'}
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    And assert response.original_name == 'Rutgers11.csv'
    Examples:
      | token                     |
      | karate.setup().adminToken |
      | karate.setup().cdaToken   |
      | karate.setup().dqToken    |


  @regression @smoke
  Scenario Outline: post file 403
    Given path '/data/files/upload'
    And header Authorization = <token>
    And multipart file file = {read:'Rutgers_11.csv', filename:'Rutgers11.csv',contentType:'text/csv'}
    When method POST
    Then status 403
    And print 'Response Body -> ',response
    And match response.description contains 'Forbidden'
    Examples:
      | token                       |
      | karate.setup().csmToken     |
      | karate.setup().supportToken |


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
      | key  | response                   |
      | ksjd | no bearer token in request |




