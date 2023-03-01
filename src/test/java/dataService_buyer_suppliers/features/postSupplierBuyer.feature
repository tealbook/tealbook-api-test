@data
Feature: post supplier buyer using data service

  Background:
    * url baseURL
    * def postSupplierBuyerRequestBody = read('../requests/supplierBuyer.json')
    * def randomCompanyName = Java.type('utils.GenerateRandomVariables').randomName()


  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken


  @regression @smoke
  Scenario Outline: post supplier buyer 201 status code
    Given path '/data/suppliers/buyer'
    And header Authorization = <token>
    * set postSupplierBuyerRequestBody.company_name = randomCompanyName
    When request postSupplierBuyerRequestBody
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    And assert response.buyer_known_as.internal_id_source == 'unknown'
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().cdaToken     |


  Scenario Outline: post supplier buyer  403 status code
    Given path '/data/suppliers/buyer'
    And header Authorization = <token>
    When request postSupplierBuyerRequestBody
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 403
    And print 'Response Body -> ',response
    And assert response.description == 'Forbidden resource'
    Examples:
      | token                   |
      | karate.setup().csmToken |
      | karate.setup().cdaToken |
      | karate.setup().dqToken  |

  @regression @smoke
  Scenario Outline: post supplier buyer details 400
    Given path '/data/suppliers/buyer'
    And header Authorization = tealbookAdminToken
    When request postSupplierBuyerRequestBody
    * remove postSupplierBuyerRequestBody $.<key>
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And match response.message contains 'null value'
    Examples:
      | key                         |
      | company_name                |
      | internal_supplier_id        |
      | internal_supplier_id_source |


  @regression @smoke
  Scenario Outline: post supplier buyer 401
    Given path '/data/suppliers/buyer'
    And header Authorization = '<key>'
    When request postSupplierBuyerRequestBody
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |


