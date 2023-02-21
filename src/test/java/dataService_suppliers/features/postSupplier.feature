Feature: suppliers - POST supplier

  Background:
    * url baseURL
    * def postSupplierRequestBody = read('../requests/postSupplier.json')
    * def randomCompanyName = Java.type('utils.GenerateRandomVariables').randomName()
    * def randomTime = Java.type('utils.GenerateRandomVariables').randomTime()
    * def randomEmail = Java.type('utils.GenerateRandomVariables').randomEmail()
    * def randomUrl = Java.type('utils.GenerateRandomVariables').randomUrl()


  @regression @smoke @postSupplier
  Scenario: post supplier
    Given path '/data/suppliers'
    And header Authorization = tealbookAdminToken
    When request postSupplierRequestBody
    * set postSupplierRequestBody.supplier_name = randomCompanyName
    * set postSupplierRequestBody.date_founded = randomTime
    * set postSupplierRequestBody.email_domain = randomEmail
    * set postSupplierRequestBody.website_url = randomUrl
    And print 'Request Body -> ',postSupplierRequestBody
    When method POST
    Then status 200
    And print 'Response Body -> ',response
    * def supplier_id = response.supplier_id
    * def supplier_name = response.supplier_name


  @regression @smoke
  Scenario Outline: post supplier details 400
    Given path '/data/suppliers'
    And header Authorization = tealbookAdminToken
    When request postSupplierRequestBody
    * remove postSupplierRequestBody $.<key>
    And print 'Request Body -> ',postSupplierRequestBody
    When method POST
    Then status 400
    And print 'Response Body -> ',response
    And assert response.description=='Input failed validation.'
    Examples:
      | key                      |
      | supplier_name            |



  @regression @smoke
  Scenario Outline: post supplier details 401
    Given path '/data/suppliers'
    And header Authorization = '<key>'
    When request postSupplierRequestBody
    And print 'Request Body -> ',postSupplierRequestBody
    When method POST
    Then status 401
    And print 'Response Body -> ',response
    And assert response.description=='<response>'
    Examples:
      | key  | response                   |
      | ksjd | no bearer token in request |




