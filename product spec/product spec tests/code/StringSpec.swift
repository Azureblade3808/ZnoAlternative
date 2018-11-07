import Foundation
import Nimble
import Quick

@testable
import product_spec

internal class StringSpec : QuickSpec {
	override
	internal func spec() {
		describe("`String`") {
			describe("`.substrings(for regex)`") {
				it("should work") {
					let string = "A bc de1 2345"
					let regex = try! NSRegularExpression(pattern: "\\w+")
					expect(string.substrings(for: regex)) == ["A", "bc", "de1", "2345"]
				}
			}
			
			describe("`.capturedGroupsInMatches(for regex)`") {
				it("should work") {
					let string = "product: LayflatBook, size: [6x6 8x8]"
					let regex = try! NSRegularExpression(pattern: "([\\w]+)\\s*:\\s*(\\w+|(?:\\[[^\\]]+\\]))")
					expect(string.capturedGroupsInMatches(for: regex)) == [
						["product: LayflatBook", "product", "LayflatBook"],
						["size: [6x6 8x8]", "size", "[6x6 8x8]"],
					]
				}
			}
		}
	}
}
