@data
Feature: supplier data - POST certification

  Background:
    * url baseURL
    * def postCertificationRequestBody = read('../requests/certificationRequest.json')
    * def randomUuid = Java.type('utils.GenerateRandomVariables').randomUuid()
    * def randomCertification = Java.type('utils.GenerateRandomVariables').randomSubCategory()
#    * def createSupplierBuyerCall = call read('postBuyerKnownAs.feature@postBuyer')
#    * def known_as_supplier_id = createSupplierBuyerCall.supplier_known_as_id
#    * def org_id = createSupplierBuyerCall.buyer_id


  @regression @smoke @postCertification
  Scenario: post supplier certification
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/certifications'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/certifications'
#    * def supplier_name = createSupplierBuyerCall.company_name
    And header Authorization = tealbookAdminToken
    When request postCertificationRequestBody
    * set postCertificationRequestBody.certification.sub_category = randomCertification
    * set postCertificationRequestBody.org_id = '3d5e1780-8c91-4e3d-92d0-ad40bb490660'
    And print 'Request Body -> ',postCertificationRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def certification_id = get response.certifications[*].certification.certification_id
    * def supplier_id = response.supplier_id
#    And assert response.supplier_name = supplier_name


  @regression @smoke
  Scenario Outline: post certification details 400
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/certifications'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/certifications'
    And header Authorization = tealbookAdminToken
    When request postCertificationRequestBody
    * remove postCertificationRequestBody $.<key>
    And print 'Request Body -> ',postCertificationRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description == 'Input failed validation.'
    Examples:
      | key                    |
      | certification          |

  @regression @smoke
  Scenario: post certification detail 404
    Given path '/data/suppliers/buyer'
    * path randomUuid + '/certifications'
    And header Authorization = tealbookAdminToken
    When request postCertificationRequestBody
    When method POST
    Then status 404
    And print 'Response Body -> ',response
    And match response.description contains 'not found'

  @regression @smoke
  Scenario Outline: post certification 401
    Given path '/data/suppliers/buyer'
#    * path known_as_supplier_id + '/certifications'
    * path 'e6b399ff-55b1-4cf6-aa5a-7d1f4e29eaaf/certifications'
    And header Authorization = '<key>'
    When request postCertificationRequestBody
    And print 'Request Body -> ',postCertificationRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




