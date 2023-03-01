Feature: supplier buyer - GET buyer internal source

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get buyers internal source detail
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def internal_supplier_id_source = createSupplierBuyerCall.internal_supplier_id_source
    * def org_id=createSupplierBuyerCall.buyer_id
    Given path '/data/suppliers/buyer/internal_source'
    * def query = {org_id : '$(org_id)'}
    And params query
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    And match response.internal_sources contains internal_supplier_id_source


  @regression @smoke
  Scenario: get buyers internal source detail 400
    Given path '/data/suppliers/buyer/internal_source'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: get buyer internal_source detail 404
    Given path '/data/suppliers/buyer/internal_source'
    * def query = {org_id : '$(randomUuid)'}
    And params query
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario: get supplier buyers detail 403
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def org_id=createSupplierBuyerCall.buyer_id
    Given path '/data/suppliers/buyer/internal_source'
    * def query = {org_id : '$(org_id)'}
    And params query
    And header Authorization = buyerOrgUserToken
    When method GET
    Then status 403
    And print 'Response Body -> ',response
    And match response.description contains 'permission'

  @regression @smoke
  Scenario Outline: get supplier buyer known as details 401
    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
    * def org_id=createSupplierBuyerCall.buyer_id
    Given path '/data/suppliers/buyer'
    * def query = {org_id : '$(org_id)'}
    And params query
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
