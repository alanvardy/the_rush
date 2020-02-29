describe('Table Test', function () {
  beforeEach(function () {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is just a simple example
    Cypress.Cookies.debug(true)
    Cypress.Cookies.preserveOnce('_the_rush_key')
  })

  it('Submits the contact form when not signed in', function () {
    var content = 'Oh I wish I were an Oscar Meyer weiner'
    var from_email = 'weiners@lots.com'
    var name = 'Weiner Wannabe'

    cy.visit('http://localhost:5000')
    cy.contains('The Rush')
  })
})
