Feature: supplier data - POST contact

  Background:
    * url baseURL
    * def postContactRequestBody = read('../requests/contactRequest.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    * def randomNum = Java.type('utils.GenerateRandomVariables').randomNum()
#    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
#    * def known_as_supplier_id = createSupplierBuyerCall.supplier_known_as_id
#    * def org_id = createSupplierBuyerCall.buyer_id


  @regression @smoke @postContact
  Scenario: post supplier contact
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/contacts'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/contacts'
#    * def supplier_name = createSupplierBuyerCall.company_name
    * def randomFirstName = Java.type('utils.GenerateRandomVariables').randomFirstName()
    * def randomLastName = Java.type('utils.GenerateRandomVariables').randomLastName()
    * def randomEmail = Java.type('utils.GenerateRandomVariables').randomEmail()
    And header Authorization = tealbookAdminToken
    When request postContactRequestBody
    * set postContactRequestBody.contact.first_name = randomFirstName
    * set postContactRequestBody.contact.last_name = randomLastName
    * set postContactRequestBody.contact.email = randomEmail
    * set postContactRequestBody.org_id = '3d5e1780-8c91-4e3d-92d0-ad40bb490660'
    And print 'Request Body -> ',postContactRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def contact_id = get response.contacts[*].contact.contact_id
    * def supplier_id = response.supplier_id
#    And assert response.supplier_name = supplier_name


  @regression @smoke
  Scenario Outline: post contact details 400
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/contacts'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/contacts'
    And header Authorization = tealbookAdminToken
    When request postContactRequestBody
    * remove postContactRequestBody $.<key>
    And print 'Request Body -> ',postContactRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'
    Examples:
      | key     |
      | contact |

  @regression @smoke
  Scenario: post contact detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/contacts'
    And header Authorization = tealbookAdminToken
    When request postContactRequestBody
    When method POST
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: post contact 401
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/contacts'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/contacts'
    And header Authorization = '<key>'
    When request postContactRequestBody
    And print 'Request Body -> ',postContactRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




