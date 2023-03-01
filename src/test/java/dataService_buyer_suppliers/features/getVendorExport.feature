@data
Feature: get vendor export using data service

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
  Scenario Outline: get vendor export 200 status code
    * def getSupplierBuyerCall = call read('getSupplierBuyer.feature@getSupplierBuyer')
    * def buyer_known_as_id = getSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id[0] + 'export/csv'
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
  Scenario: GET vendor export 400
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '12345' + 'export/csv'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.description contains 'invalid input'

  @regression @smoke
  Scenario: get vendor export  404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path randomUuid + 'export/csv'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: get vendor export  401
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '12345' + 'export/csv'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description == '<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |

