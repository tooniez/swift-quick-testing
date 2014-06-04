//
//  QuickTests.swift
//  QuickTests
//
//  Created by Brian Ivan Gesiak on 6/5/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

import XCTest

class Person {
	var isHappy = true
	var greeting: String {
		get {
			if isHappy {
				return "Hello!"
			} else {
				return "Oh, hi."
			}
		}
	}
}

class QuickTests: XCTestCase {
	func testDSL() {
		describe("Person") {
			var person: Person?
			beforeEach() { person = Person() }
			afterEach() { person = nil }


			it("is happy") {
				XCTAssert(person!.isHappy, "expected person to be happy by default")
			}

			describe("greeting") {
				context("when the person is unhappy") {
					beforeEach() { person!.isHappy = false }
					it("is lukewarm") {
						XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a lukewarm greeting")
					}
				}

				context("when the person is happy") {
					beforeEach() { person!.isHappy = true }
					it("is enthusiastic") {
						XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
					}
				}
			}
		}
	}

    func testWithoutDSL() {
		var root = ExampleGroup("Person")

		var person: Person?
		root.localBefores.append() {
			person = Person()
		}

		var itIsHappy = Example("is happy") {
			XCTAssert(person!.isHappy, "expected person to be happy by default")
		}
		root.appendExample(itIsHappy)

		var whenUnhappy = ExampleGroup("when the person is unhappy")
		whenUnhappy.localBefores.append() {
			person!.isHappy = false
		}
		var itGreetsHalfheartedly = Example("greets halfheartedly") {
			XCTAssertEqualObjects(person!.greeting, "Oh, hi.", "expected a halfhearted greeting")
		}
		whenUnhappy.appendExample(itGreetsHalfheartedly)
		root.appendExampleGroup(whenUnhappy)

		var whenHappy = ExampleGroup("when the person is happy")
		var itGreetsEnthusiastically = Example("greets enthusiastically") {
			XCTAssertEqualObjects(person!.greeting, "Hello!", "expected an enthusiastic greeting")
		}
		whenHappy.appendExample(itGreetsEnthusiastically)
		root.appendExampleGroup(whenHappy)

		root.run()
    }
}