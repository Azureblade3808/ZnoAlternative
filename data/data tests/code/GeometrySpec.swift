import Nimble
import Quick

import data

internal class GeometrySpec : QuickSpec {
	override
	internal func spec() {
		describe("`Offset`") {
			it("can be negated") {
				expect(-Offset(x: 1, y: 2)) == Offset(x: -1, y: -2)
			}
			
			it("can add another `Offset`") {
				expect(Offset(x: 1, y: 2) + Offset(x: 3, y: 4)) == Offset(x: 4, y: 6)
			}
			
			it("can minus another `Offset`") {
				expect(Offset(x: 1, y: 2) - Offset(x: 3, y: 4)) == Offset(x: -2, y: -2)
			}
			
			it("can multiply a `Double`") {
				expect(Offset(x: 1, y: 2) * 3) == Offset(x: 3, y: 6)
			}
			
			it("can be divided by a `Double`") {
				expect(Offset(x: 1, y: 2) / 2) == Offset(x: 0.5, y: 1)
			}
		}
		
		describe("`Padding`") {
			it("can be negated") {
				expect(-Padding(left: 1, top: 2, right: 3, bottom: 4)) == Padding(left: -1, top: -2, right: -3, bottom: -4)
			}
			
			it("can add another `Padding`") {
				expect(
					Padding(left: 1, top: 2, right: 3, bottom: 4) + Padding(left: 5, top: 6, right: 7, bottom: 8)
				) == (
					Padding(left: 6, top: 8, right: 10, bottom: 12)
				)
			}
			
			it("can minus another `Padding`") {
				expect(
					Padding(left: 1, top: 2, right: 3, bottom: 4) - Padding(left: 5, top: 6, right: 7, bottom: 8)
				) == (
					Padding(left: -4, top: -4, right: -4, bottom: -4)
				)
			}
			
			it("can multiply a `Double`") {
				expect(Padding(left: 1, top: 2, right: 3, bottom: 4) * 5) == Padding(left: 5, top: 10, right: 15, bottom: 20)
			}
			
			it("can be divided by a `Double`") {
				expect(Padding(left: 1, top: 2, right: 3, bottom: 4) / 2) == Padding(left: 0.5, top: 1, right: 1.5, bottom: 2)
			}
		}
		
		describe("`Rectangle`") {
			it("can add a `Padding`") {
				expect(
					Rectangle(center: Offset(x: 1, y: 2), size: Offset(x: 3, y: 4)) + Padding(left: 5, top: 6, right: 7, bottom: 8)
				) == (
					Rectangle(center: Offset(x: 2, y: 3), size: Offset(x: 15, y: 18))
				)
			}
			
			it("can minus a `Padding`") {
				expect(
					Rectangle(center: Offset(x: 1, y: 2), size: Offset(x: 3, y: 4)) - Padding(left: 5, top: 6, right: 7, bottom: 8)
				) == (
					Rectangle(center: Offset(x: 0, y: 1), size: Offset(x: -9, y: -10))
				)
			}
		}
	}
}
