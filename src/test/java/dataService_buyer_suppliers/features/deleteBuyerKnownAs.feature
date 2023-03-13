@data
Feature: supplier buy - DELETE supplier buyer known as

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
  Scenario Outline: delete supplier buyer known as 200
    * def getSupplierBuyerCall = call read('getSupplierBuyer.feature@getSupplierBuyer')
    * def buyer_known_as_id = getSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id[0]
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 200
    And print 'Response Body -> ',response
    And match response.data[*].supplier_buyer_known_as.supplier_buyer_known_as_id !contains buyer_known_as_id[0]
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().cdaToken     |

  @regression @smoke
  Scenario Outline: delete supplier buyer known as 403
    * def getSupplierBuyerCall = call read('getSupplierBuyer.feature@getSupplierBuyer')
    * def buyer_known_as_id = getSupplierBuyerCall.buyer_known_as_id
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path buyer_known_as_id[0]
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 403
    And print 'Response Body -> ',response
    And match response.description contains 'forbidden'
    Examples:
      | token                   |
      | karate.setup().csmToken |
      | karate.setup().dqToken  |


  @regression @smoke
  Scenario: delete supplier buyer known as detail 400
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: delete supplier buyer known as detail 404
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method DELETE
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: delete supplier buyer known as details 401
    Given path '/data/suppliers/buyer/buyer_known_as'
    * path '1234'
    And header Authorization = '<key>'
    When method DELETE
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |
