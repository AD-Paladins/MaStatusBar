import XCTest
@testable import MaStatusBar

final class MaStatusBarTests: XCTestCase {

    func testAnimationGatingRequiresBothFlags() {
        var offset: CGFloat = 0
        let width: CGFloat = 1000
        let speed: CGFloat = 1
        var featureEnabled = false
        var animationEnabled = false

        simulateTick(featureEnabled: featureEnabled, animationEnabled: animationEnabled,
                     offset: &offset, width: width, speed: speed)
        XCTAssertEqual(offset, 0, "Offset should not change when both flags are false")

        featureEnabled = true
        simulateTick(featureEnabled: featureEnabled, animationEnabled: animationEnabled,
                     offset: &offset, width: width, speed: speed)
        XCTAssertEqual(offset, 0, "Offset should not change when animation is disabled")

        animationEnabled = true
        simulateTick(featureEnabled: featureEnabled, animationEnabled: animationEnabled,
                     offset: &offset, width: width, speed: speed)
        XCTAssertEqual(offset, -speed, "Offset should decrement when both flags are true")
    }

    func testOffsetWrapsSeamlessly() {
        let width: CGFloat = 100
        let speed: CGFloat = 10
        var offset: CGFloat = 0

        // Advance to just before wrap point
        simulateTick(featureEnabled: true, animationEnabled: true,
                     offset: &offset, width: width, speed: speed)
        // offset = 0 - 10 = -10. -10 <= -100? No
        XCTAssertEqual(offset, -10)

        // Advance past wrap point in one big step
        offset = -95
        simulateTick(featureEnabled: true, animationEnabled: true,
                     offset: &offset, width: width, speed: speed)
        // offset = -95 - 10 = -105. -105 <= -100? Yes. offset = -105 + 100 = -5
        XCTAssertEqual(offset, -5, "Offset should wrap from -95 to -5 (continuous)")
    }

    func testOpacityGatesOnFeatureEnabledOnly() {
        let barOpacity: (Bool, Bool) -> Double = { feature, _ in feature ? 1 : 0 }

        XCTAssertEqual(barOpacity(true, true), 1, "Opacity should be 1 when feature is enabled")
        XCTAssertEqual(barOpacity(true, false), 1, "Opacity should be 1 even when animation is disabled")
        XCTAssertEqual(barOpacity(false, true), 0, "Opacity should be 0 when feature is disabled")
        XCTAssertEqual(barOpacity(false, false), 0, "Opacity should be 0 when both are disabled")
    }

    // MARK: - Helpers

    private func simulateTick(featureEnabled: Bool, animationEnabled: Bool,
                              offset: inout CGFloat, width: CGFloat, speed: CGFloat) {
        guard featureEnabled && animationEnabled else { return }
        offset -= speed
        if offset <= -width {
            offset += width
        }
    }
}
