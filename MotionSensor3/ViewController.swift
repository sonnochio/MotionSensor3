import UIKit
import CoreMotion
import SwiftOSC

class ViewController: UIViewController {
    
    // Initialize the motion manager
    let motionManager = CMMotionManager()
    
    // Initialize the OSC client
    let client = OSCClient(address: "your-computer-ip", port: 6448)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if accelerometer updates are available
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                guard let data = data else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
                
                // Send this data via OSC
                self.sendOSCMessage(x: x, y: y, z: z)
            }
        } else {
            print("Accelerometer is not available on this device.")
        }
    }

    func sendOSCMessage(x: Double, y: Double, z: Double) {
        let message = OSCMessage("/accelerometer", x, y, z)
        client.send(message)
    }
}
