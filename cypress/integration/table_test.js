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

  it('Gets the main page', function () {
    cy.visit('http://localhost:5000')
    cy.contains('The Rush')
    cy.contains('Alex Smith')
  })

  it('Can reverse sort players', function () {
    cy.visit('http://localhost:5000')
    cy.contains('Alex Smith')
    cy.get('a.sort-button').first().click()
    cy.contains('Zach Zenner')
  })

  it('Can go to page 4', function () {
    cy.visit('http://localhost:5000')
    cy.get('.pagination').contains('4').click()
    cy.contains('Jonathan Williams')
  })

  it('Can search for Mack Brown', function () {
    cy.visit('http://localhost:5000')
    cy.get('input[id="search_search"]').type('mackb')
    cy.contains('Mack Brown')
    cy.contains('WAS')
    cy.contains('RB')
  })

  it('Gets 10k records', function () {
    cy.visit('http://localhost:5000/ten_thousand')
    cy.get('.pagination').contains('203')
  })
})
