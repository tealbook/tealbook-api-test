@data
Feature: pipelines - GET supplier

  Background:
    * url baseURL


  @regression @smoke
  Scenario: get supplier id detail
    * def createSupplierCall = call read('postSupplier.feature@postSupplier')
    * def supplierId = createSupplierCall.supplier_id
    * def supplierName = createSupplierCall.supplier_name
    Given path '/data/suppliers'
    * path supplierId
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response[0].supplier_name == supplierName



  @regression @smoke
  Scenario: get supplier id detail 400
    Given path '/data/suppliers'
    * path '12345'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'

  @regression @smoke
  Scenario: get supplier id detail 404
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    Given path '/data/suppliers'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: get supplier details 401
    * def createSupplierCall = call read('postSupplier.feature@postSupplier')
    * def supplierId = createSupplierCall.supplier_id
    Given path '/data/suppliers'
    * path supplierId
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
