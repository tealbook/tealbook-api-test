Feature: supplier data - PUT contact

  Background:
    * url baseURL
    * def postContactRequestBody = read('../requests/contactRequest.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()


  @regression @smoke
  Scenario Outline: put contacts
    * def createContactsCall = call read('postContact.feature@postContact')
    * def contact_id = createContactsCall.contact_id
    * def supplier_id = createContactsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/contacts'
    * path contact_id[0]
    And header Authorization = tealbookAdminToken
    And header Content-Type = 'application/json; charset=utf-8'
    * def payload = '<requestPayload>'
    When request payload
    * print payload
    When method PUT
    Then status 200
    And print 'Response Body -> ',response
    Examples:
      | requestPayload                                                                                    |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"title":"qa test"}}                  |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"entity_source":"qa test"}}          |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"last_name":"abc"}}                  |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"email":"qa_test@gmail.com"}}        |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"contact_description":"qa_test"}}    |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"preferred_language_code":"none"}}   |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"name_string":"full qa test"}}       |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"mobile_phone_number":"1231234567"}} |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"first_name":"qa_test"}}             |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"meta_data":{}}}                     |
      | {"org_id": "3d5e1780-8c91-4e3d-92d0-ad40bb490660","contact":{"location_string":"test"}}           |


  @regression @smoke
  Scenario: put contacts 400
    * def createContactsCall = call read('postContact.feature@postContact')
    * def contact_id = createContactsCall.contact_id
    * def supplier_id = createContactsCall.supplier_id
    Given path '/data/suppliers/buyer'
    * path supplier_id + '/contacts'
    * path contact_id[0]
    And header Authorization = tealbookAdminToken
    * def payload = {"abc": "cbd"}
    When request payload
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'


  @regression @smoke
  Scenario: put contacts 400
    Given path '/data/suppliers/buyer'
    * path '123/contacts'
    * path '123'
    And header Authorization = tealbookAdminToken
    When request postContactRequestBody
    When method PUT
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'

  @regression @smoke
  Scenario: put contact detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    * path randomUuid
    And header Authorization = tealbookAdminToken
    When request postContactRequestBody
    When method PUT
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'


  @regression @smoke
  Scenario Outline: put contact details 401
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    * path randomUuid
    And header Authorization = '<key>'
    When request postContactRequestBody
    And print 'Request Body -> ',postContactRequestBody
    When method PUT
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




