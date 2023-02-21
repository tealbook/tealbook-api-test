Feature: supplier data - GET address

  Background:
    * url baseURL
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario: get address detail
    * def createAddressesCall = call read('postAddress.feature@postAddress')
    * def address_id = createAddressesCall.address_id
    * def supplier_id = createAddressesCall.supplier_id
    * print address_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/addresses'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 200
    And print 'Response Body -> ',response
    * def responses = get response[*]
    * def address_ids = $responses[*].address.address_id
    And match address_ids contains deep address_id

  @regression @smoke
  Scenario: get Addresses detail 400
    Given path '/data/suppliers/buyer'
    * path '12345/addresses'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: get address detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    And header Authorization = tealbookAdminToken
    When method GET
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: get address details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    And header Authorization = '<key>'
    When method GET
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key          | response                   |
      | ksjd         | no bearer token in request |
