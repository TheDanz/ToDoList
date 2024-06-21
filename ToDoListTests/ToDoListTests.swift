import XCTest
@testable import ToDoList

final class ToDoListTests: XCTestCase {
    
    let todoItemWithoutId = ToDoItem(text: "text1", importance: .important, isDone: false)
    let jsonWithoutImportance: [String: Any] = [ "id": "2", "text": "text2", "isDone": true]
    let jsonWithImportantImportance: [String: Any] = ["id": "3", "text": "text3", "importance": "important", "isDone": true]
    let jsonWithUnimportantImportance: [String: Any] = ["id": "4", "text": "text4", "importance": "unimportant", "isDone": true]
    let jsonWithDeadline: [String: Any] = ["id": "5", "text": "text5", "isDone": true, "deadline": "2024-06-20T08:14:14Z"]
    let jsonWithoutDeadline: [String: Any] = ["id": "6", "text": "text6", "isDone": true]
    let jsonWithCompletedTask: [String: Any] = ["id": "7",  "text": "text7", "isDone": true]
    let jsonWithUncompletedTask: [String: Any] = ["id": "8", "text": "text8", "isDone": false]
    let jsonWithoutID: [String: Any] = ["text": "text9", "importance": "unimportant", "isDone": true]
    let jsonWithoutText: [String: Any] = ["importance": "unimportant", "isDone": true]
    let jsonWithoutIsDone: [String: Any] = ["id": "11", "text": "text11", "importance": "unimportant"]
    let jsonWithUpperAndLowerCaseImportance: [String: Any] = ["id": "12", "text": "text12", "importance": "uNiMpOrTaNt", "isDone": true]
    let csvLineWithTextWithSeparator = "345;\"Погулять;с собакой\";\"normal\";2024-06-20T05:48:05Z;true"
    let csvLineWithUpperAndLowerCaseImportance = "987;\"consider\";\"unIMPORTANT\";2024-06-20T05:48:05Z;true"
    let csvLineWithIncorrectImportance = "124;\"someText\";\"sakjdj\";2024-06-20T05:48:05Z;true"
    let csvLineWithIncorrectIsDone = "125;\"someText\";\"normal\";2024-06-20T05:48:05Z;truee"
    let csvLineWithHeaders = """
                                id;text;importance;deadline;isDone
                                123;"Помыть посуду";"unimportant";2024-06-20T05:48:05Z;false
                                345;"Погулять;с собакой";"normal";2024-06-20T05:48:05Z;true
                                987;"Сходить на пары";"unIMPORTANT";2024-06-20T05:48:05Z;true
                                124;"Сдать сессию";"normal";2024-06-20T05:48:05Z;true
                            """
    
    func testIdIsCreatedAutomatically() {
        XCTAssertTrue(!todoItemWithoutId.id.isEmpty)
    }
    
    func testImportanceIsNormalAfterParsingEmptyImportance() {
        let expected = ToDoItem.Importance.normal
        if let todoItem = ToDoItem.parse(json: jsonWithoutImportance) {
            XCTAssertEqual(expected, todoItem.importance)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testImportanceIsImportantAfterParsingImportantImportance() {
        let expected = ToDoItem.Importance.important
        if let todoItem = ToDoItem.parse(json: jsonWithImportantImportance) {
            XCTAssertEqual(expected, todoItem.importance)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testImportanceIsUnimportantAfterParsingUnimportantImportance() {
        let expected = ToDoItem.Importance.unimportant
        if let todoItem = ToDoItem.parse(json: jsonWithUnimportantImportance) {
            XCTAssertEqual(expected, todoItem.importance)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testDeadlineExistsAfterCreationWithDeadline() {
        if let todoItem = ToDoItem.parse(json: jsonWithDeadline) {
            XCTAssertNotNil(todoItem.deadline)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testDeadlineDoesNotExistsAfterCreationWithoutDeadline() {
        if let todoItem = ToDoItem.parse(json: jsonWithoutDeadline) {
            XCTAssertNil(todoItem.deadline)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testTaskIsCompletedAfterParsing() {
        if let todoItem = ToDoItem.parse(json: jsonWithCompletedTask) {
            XCTAssertTrue(todoItem.isDone)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testTaskIsUncomplitedAfterParsing() {
        if let todoItem = ToDoItem.parse(json: jsonWithUncompletedTask) {
            XCTAssertFalse(todoItem.isDone)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testParseJsonReturnsNilIfIdDoesNotExist() {
        let toDoItem = ToDoItem.parse(json: jsonWithoutID)
        XCTAssertNil(toDoItem)
    }
    
    func testParseJsonReturnsNilIfTextDoesNotExist() {
        let toDoItem = ToDoItem.parse(json: jsonWithoutText)
        XCTAssertNil(toDoItem)
    }
    
    func testParseJsonReturnsNilIfIsDoneDoesNotExist() {
        let toDoItem = ToDoItem.parse(json: jsonWithoutIsDone)
        XCTAssertNil(toDoItem)
    }
    
    func testParseJsonIsSuccessfullIfImportanceHasDifferentRegisters() {
        let expected = ToDoItem.Importance.unimportant
        if let toDoItem = ToDoItem.parse(json: jsonWithUpperAndLowerCaseImportance) {
            XCTAssertEqual(expected, toDoItem.importance)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testInitCsvIsSuccessfullWithSeparatorInTextCell() {
        if let toDoItem = ToDoItem(csvLine: csvLineWithTextWithSeparator, separator: ";") {
            XCTAssertNotNil(toDoItem)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testInitCsvIsSuccessfullIfImportanceHasDifferentRegisters() {
        let expected = ToDoItem.Importance.unimportant
        if let toDoItem = ToDoItem(csvLine: csvLineWithUpperAndLowerCaseImportance, separator: ";") {
            XCTAssertEqual(expected, toDoItem.importance)
        } else {
            XCTFail("ToDoItem is nil")
        }
    }
    
    func testInitCsvIsFailureIfImportanceIsIncorrect() {
        let toDoItem = ToDoItem(csvLine: csvLineWithIncorrectImportance, separator: ";")
        XCTAssertNil(toDoItem)
    }
    
    func testInitCsvIsFailureIfIsDoneIsIncorrect() {
        let toDoItem = ToDoItem(csvLine: csvLineWithIncorrectIsDone, separator: ";")
        XCTAssertNil(toDoItem)
    }
    
    func testParseCsvRemoveOneLineIfHeadersExist() {
        let expected = 4
        let testBundle = Bundle(for: type(of: self))
        
        if let fileURL = testBundle.url(forResource: "csvFileWithHeaders", withExtension: "csv") {
            let toDoItems = ToDoItem.parseCSV(fileURL: fileURL, isHeaders: true)
            XCTAssertEqual(expected, toDoItems.count)
        } else {
            XCTFail("File csvFileWithHeaders.csv does not exists")
        }
    }
    
    func testParseCsvDoesNotRemoveOneLineIfHeadersExist() {
        let expected = 4
        let testBundle = Bundle(for: type(of: self))
        
        if let fileURL = testBundle.url(forResource: "csvFileWithoutHeaders", withExtension: "csv") {
            let toDoItems = ToDoItem.parseCSV(fileURL: fileURL, isHeaders: false)
            XCTAssertEqual(expected, toDoItems.count)
        } else {
            XCTFail("File csvFileWithHeaders.csv does not exists")
        }
    }
}
