@data
Feature: supplier data - PUT address

  Background:
    * url baseURL
    * def postAddressRequestBody = read('../requests/addressRequest.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: put Addresses
    * def createAddressesCall = call read('postAddress.feature@postAddress')
    * def address_id = createAddressesCall.address_id
    * def supplier_id = createAddressesCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/addresses'
    * path address_id[0]
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    * def payload = '<requestPayload>'
    When request payload
    * print payload
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | requestPayload                                                                                 |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"state":"qa test"}}               |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"addressline":"qa test"}}         |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"country":"abc"}}                 |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"city":"qa_test"}}                |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"entity_source":"vendor"}}        |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"pcode":"none"}}                  |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"address_string":"full qa test"}} |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"fax_number":"1231234567"}}       |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address":{"phone_number":"qa_test"}}        |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","address_type":"physical"}                   |


  @regression @smoke
  Scenario: put Addresses 400
    * def createAddressesCall = call read('postAddress.feature@postAddress')
    * def address_id = createAddressesCall.address_id
    * def supplier_id = createAddressesCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/addresses'
    * path address_id[0]
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: put Addresses 400
    Given path '/data/suppliers/buyer'
    * path '123/addresses'
    * path '123'
    And header Authorization = tealbookAdminToken
    When request postAddressRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: put address detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When request postAddressRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: put address details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/addresses'
    * path randomUuid
    And header Authorization = '<key>'
    When request postAddressRequestBody
    And print 'Request Body -> ',postAddressRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




