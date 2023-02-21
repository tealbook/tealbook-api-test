Feature: supplier buyer - POST buyerKnownAs

  Background:
    * url baseURL
    * def postSupplierBuyerRequestBody = read('../requests/buyerKnownAs.json')
    * def randomCompanyName = Java.type('utils.GenerateRandomVariables').randomName()
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    * def randomNum = Java.type('utils.GenerateRandomVariables').randomNum()


  @regression @smoke @postBuyer
  Scenario: post buyerKnownAs
    Given path '/data/suppliers/buyer/buyer_known_as'
    And header Authorization = tealbookAdminToken
    When request postSupplierBuyerRequestBody
    * set postSupplierBuyerRequestBody.company_name = randomCompanyName
    * set postSupplierBuyerRequestBody.internal_supplier_id = randomNum
    * set postSupplierBuyerRequestBody.supplier_buyer_id = randomUuid
    * set postSupplierBuyerRequestBody.known_as_supplier_id = randomUuid
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def supplier_buyer_id = response.supplier_buyer_id
    * def buyer_known_as_id = response.supplier_buyer_known_as_id
    * def known_as_supplier_id = response.known_as_supplier_id
    * def internal_supplier_id = response.internal_supplier_id
    * def internal_supplier_id_source = response.internal_supplier_id_source
    * def org_id = response.buyer_id
    * def company_name = response.company_name
    And assert response.company_name = randomCompanyName


  @regression @smoke
  Scenario Outline: post buyweKnownAs details 400
    Given path '/data/suppliers/buyer/buyer_known_as'
    And header Authorization = tealbookAdminToken
    When request postSupplierBuyerRequestBody
    * remove postSupplierBuyerRequestBody $.<key>
    And print 'Request Body -> ',postSupplierBuyerRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'
    Examples:
      | key                         |
      | company_name                |
      | internal_supplier_id        |
      | internal_supplier_id_source |


  @regression @smoke
  Scenario Outline: post buyerKnownAs details 401
    Given path '/data/suppliers/buyer/buyer_known_as'
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




