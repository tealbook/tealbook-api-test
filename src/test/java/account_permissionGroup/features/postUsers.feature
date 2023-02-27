@accounts
Feature: post user using account service

  Background:
    * url baseURL
    * def postUserRequestBody = read('../requests/postUser.json')
    * def randomFirstName = Java.type('utils.GenerateRandomVariables').randomFirstName()
    * def randomLastName = Java.type('utils.GenerateRandomVariables').randomLastName()
    * def randomEmail = Java.type('utils.GenerateRandomVariables').randomEmail()

  @setup
  Scenario:
    * def adminToken = tealbookAdminToken
    * def supportToken = tealbookSupportToken
    * def csmToken = tealbookCsmToken
    * def dqToken = tealbookDqToken
    * def cdaToken = tealbookCdaToken

  @postUser
  Scenario: post user 201
    Given path '/accounts/user'
    And header Authorization = tealbookAdminToken
    When request postUserRequestBody
    * set postUserRequestBody.firstName = randomFirstName
    * set postUserRequestBody.lastName = randomLastName
    * set postUserRequestBody.email = randomEmail
    And print 'Request Body -> ',postUserRequestBody
    When method POST
    Then status 201
    And print 'Response Body -> ',response
    * def user_id = response.id
    * def user_email = response.email
    * def firstName = response.firstName
    * def lastName = response.lastName
    * def enabled = response.enabled
    * def org_id = response.orgId

