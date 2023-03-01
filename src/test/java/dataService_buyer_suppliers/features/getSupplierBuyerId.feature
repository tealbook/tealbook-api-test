Feature: supplier buy - GET supplier buyer

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
  Scenario Outline: get supplier buyer detail 200
    * def getSupplierBuyerCall = call read('getSupplierBuyer.feature@getSupplierBuyer')
    * def buyer_supplier_id  = getSupplierBuyerCall.buyer_supplier_id
    * def companyName = getSupplierBuyerCall.company_name
    Given path '/data/suppliers/buyer'
    * path buyer_supplier_id[0]
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.buyer_known_as[0].company_name == companyName[0]
    Examples:
      | token                       |
      | karate.setup().adminToken   |
      | karate.setup().supportToken |
      | karate.setup().csmToken     |
      | karate.setup().cdaToken     |
      | karate.setup().dqToken      |



  @regression @smoke
  Scenario: get supplier buyer known as detail 400
    Given path '/data/suppliers/buyer'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: get supplier buyer known as detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: get supplier buyer known as details 401
    Given path '/data/suppliers/buyer'
    * path '12345'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description == '<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
