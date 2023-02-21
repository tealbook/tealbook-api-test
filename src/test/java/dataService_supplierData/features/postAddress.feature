Feature: supplier data - POST address

  Background:
    * url baseURL
    * def postAddressRequestBody = read('../requests/addressRequest.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    * def randomAddress = Java.type('utils.GenerateRandomVariables').randomAddress()
#    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
#    * def known_as_supplier_id = createSupplierBuyerCall.supplier_known_as_id
#    * def org_id = createSupplierBuyerCall.buyer_id


  @regression @smoke @postAddress
  Scenario: post supplier address
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/addresses'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/addresses'
#    * def supplier_name = createSupplierBuyerCall.company_name
    And header Authorization = tealbookAdminToken
    When request postAddressRequestBody
    * set postAddressRequestBody.address.address_string = randomAddress
    * set postAddressRequestBody.org_id = '3d5e1780-8c91-4e3d-92d0-ad40bb490660'
    And print 'Request Body -> ',postAddressRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def address_id = get response.addresses[*].address.address_id
    * def supplier_id = response.supplier_id
#    And assert response.supplier_name = supplier_name


  @regression @smoke
  Scenario Outline: post address details 400
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/addresses'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/addresses'
    And header Authorization = tealbookAdminToken
    When request postAddressRequestBody
    * remove postAddressRequestBody $.<key>
    And print 'Request Body -> ',postAddressRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'
    Examples:
      | key     |
      | address |

  @regression @smoke
  Scenario: post address detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    And header Authorization = tealbookAdminToken
    When request postAddressRequestBody
    When method POST
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: post address 401
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/addresses'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/addresses'
    And header Authorization = '<key>'
    When request postAddressRequestBody
    And print 'Request Body -> ',postAddressRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




