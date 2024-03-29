import XCTest

class ContactAppUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAddContactSuccess() {
        app.navigationBars["Contact"].buttons["Add"].tap()
        let contactView = app.otherElements["AddContactView"]
        XCTAssert(contactView.exists)
        let firstNameTextfiled = contactView.textFields["FirstName"]
        XCTAssert(firstNameTextfiled.exists)
        firstNameTextfiled.tap()
        firstNameTextfiled.typeText("huy")
        
        let lastNameTextfiled = contactView.textFields["LastName"]
        XCTAssert(lastNameTextfiled.exists)
        lastNameTextfiled.tap()
        lastNameTextfiled.typeText("UITestSuccess")
        
        let mobileTextfiled = contactView.textFields["Mobile"]
        XCTAssert(mobileTextfiled.exists)
        mobileTextfiled.tap()
        mobileTextfiled.typeText("1234567890")
        
        let emailTextfiled = contactView.textFields["Email"]
        XCTAssert(emailTextfiled.exists)
        emailTextfiled.tap()
        emailTextfiled.typeText("huytest@yahoo.com")
        
        app.navigationBars["Add Contact"].buttons["Done"].tap()
        sleep(3)
        XCTAssert(app.otherElements["ContactList"].exists)
    }
    
    func testAddContactFail() {
        app.navigationBars["Contact"].buttons["Add"].tap()
        let contactView = app.otherElements["AddContactView"]
        XCTAssert(contactView.exists)
        let firstNameTextfiled = contactView.textFields["FirstName"]
        XCTAssert(firstNameTextfiled.exists)
        firstNameTextfiled.tap()
        firstNameTextfiled.typeText("huy")
        
        let lastNameTextfiled = contactView.textFields["LastName"]
        XCTAssert(lastNameTextfiled.exists)
        lastNameTextfiled.tap()
        lastNameTextfiled.typeText("UITestFail")
        
        let mobileTextfiled = contactView.textFields["Mobile"]
        XCTAssert(mobileTextfiled.exists)
        mobileTextfiled.tap()
        mobileTextfiled.typeText("1234567890")
        
        let emailTextfiled = contactView.textFields["Email"]
        XCTAssert(emailTextfiled.exists)
        emailTextfiled.tap()
        emailTextfiled.typeText("wrongemail")
        
        app.navigationBars["Add Contact"].buttons["Done"].tap()
        sleep(2)
        XCTAssert(app.alerts.element.staticTexts["Email is invalid"].exists)
    }
    
    func testDidClickContactCell() {
        let contactListView = app.otherElements["ContactList"]
        XCTAssert(contactListView.exists)
        
        sleep(1)
        XCTAssert(app.tables.element.exists)
        let cell = app.tables.cells["ContactCell_0_0"]
        XCTAssert(cell.exists)
        cell.tap()
        let detailView = app.otherElements["DetailContact"]
        XCTAssert(detailView.exists)
    }
    
    func testDetaiViewMessageButtonDidClick() {
        let contactListView = app.otherElements["ContactList"]
        XCTAssert(contactListView.exists)
        
        sleep(1)
        XCTAssert(app.tables.element.exists)
        let cell = app.tables.cells["ContactCell_0_0"]
        XCTAssert(cell.exists)
        cell.tap()
        let detailView = app.otherElements["DetailContact"]
        XCTAssert(detailView.exists)
        let messageButton = detailView.buttons["MessageButton"]
        messageButton.tap()
        sleep(1)
        XCTAssert(app.otherElements["MessageView"].exists)
    }
    
    func testDetaiViewEmailButtonDidClick() {
        let contactListView = app.otherElements["ContactList"]
        XCTAssert(contactListView.exists)
        
        sleep(1)
        XCTAssert(app.tables.element.exists)
        let cell = app.tables.cells["ContactCell_0_0"]
        XCTAssert(cell.exists)
        cell.tap()
        let detailView = app.otherElements["DetailContact"]
        XCTAssert(detailView.exists)
        let emailButton = detailView.buttons["EmailButton"]
        emailButton.tap()
        sleep(1)
        XCTAssert(app.otherElements["EmailView"].exists)
    }
}


//


