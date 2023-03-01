@data
Feature: search supplierBuyer using data service

  Background:
    * url baseURL

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken
    * def createSupplierBuyerCall = call read('postSupplierBuyer.feature@postSupplierBuyer')
    * def internalSupplierId = createSupplierBuyerCall.internalSupplierId
    * def internalSupplierIdSource = createSupplierBuyerCall.internalSupplierIdSource
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: search supplierBuyer 200 status code
    Given path '/data/suppliers/buyer'
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
  Scenario Outline: search supplierBuyer 200 status code
    Given path '/data/suppliers/buyer'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def suppliers = get response.data[*].tealbook_supplier.supplier_name
    * def internalIdSource = get response.data[*].supplier_buyer.buyer_known_as[*].internal_supplier_id_source
    * def internalIds = get response.data[*].supplier_buyer.buyer_known_as[*].internal_supplier_id
    * def results = ('<key>'=='limit')? suppliers.size:('<key>'=='internal_supplier_id_source')? internalIdSource: internalIds
    And print results

    Examples:
      | key                         | value                                   |
      | limit                       | 9                                       |
      | internal_supplier_id_source | karate.setup().internalSupplierIdSource |
      | internal_supplier_ids       | karate.setup().internalSupplierId       |


  @getSupplierBuyer
  Scenario: search supplierBuyer 200 status code
    Given path '/data/suppliers/buyer'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    * print response
    * def buyer_supplier_id = get response.data[*].supplier_buyer_known_as.known_as_supplier_id
    * def buyer_known_as_id = get response.data[*].supplier_buyer_known_as.supplier_buyer_known_as_id
    * def company_name = get response.data[*].supplier_buyer_known_as.company_name
    * print buyer_supplier_id
    * print buyer_known_as_id
    * print company_name


  @regression @smoke
  Scenario Outline: search supplierBuyer 400 status code
    Given path '/data/suppliers/buyer'
    And param <key>  = <value>
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And match response.description contains 'Invalid input'
    Examples:
      | key                         | value  |
      | internal_supplier_id_source | '1234' |
      | internal_supplier_ids       | '$%^'  |

  @regression @smoke
  Scenario: search supplierBuyer 404 status code
    Given path '/data/suppliers/buyer'
    And param internal_supplier_id_source  = 'hello'
    And param internal_supplier_ids = 1
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: get supplierBuyer details 401
    Given path '/data/suppliers/buyer'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And match response.description contains '<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |

