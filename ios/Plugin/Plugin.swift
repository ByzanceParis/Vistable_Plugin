import Foundation
import Capacitor
import AVFoundation
import CoreBluetooth
import UIKit
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(VistablePlugin)
public class VistablePlugin: CAPPlugin {

    var bleManager :BleManager?
    var ledString:String?
    var callbackId:String?
    var unicId:String?
    var callerFn:CAPPluginCall?


    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": value
        ])
    }

    @objc func initManager(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""

        // Plugin Command Arguments
        let key:String = call.getString("apikey") ?? ""
        var name:String = call.getString("name") ?? ""
        name = "BLE-"+name

        self.callerFn = call

        self.unicId  = UIDevice.current.identifierForVendor?.uuidString
        NotificationCenter.default.addObserver(self, selector:  #selector(onBle), name: Notification.Name(rawValue: "vistaBleMsg"), object: nil)
        self.bleManager = BleManager()
        self.bleManager?.start(name:name)
    }

    @objc func turnOn(_ call: CAPPluginCall) {


        let win = call.getString("win") ?? "0"
        let second = call.getString("second") ?? "1"
        let third = call.getString("third") ?? "2"
//        var ids = call.getArray("ids", Array<Int>.self)
        var stringRepresentation:String = self.unicId! + "&"

        stringRepresentation += win + ":FF0000&"
        stringRepresentation += second + ":FF0000&"
        stringRepresentation += third + ":FF0000&"

        self.ledString = stringRepresentation
        self.bleManager?.turnOn(id: stringRepresentation)
        call.resolve([
            "value": "SENT"
        ])
    }

    @objc func turnOff(_ call: CAPPluginCall) {
        if self.ledString != nil {
            self.bleManager?.turnOff(id: self.ledString!);
        }
        call.resolve([
            "value": "SENT"
        ])
    }


    @objc func onBle(notification: Notification){
      print("new message")
      let message = notification.userInfo!["message"] as! String
      if (message == "connected") {
        self.callerFn?.resolve([
            "value": message
        ])
        } else {
            self.callerFn?.reject(message)
        }
    }


}




class BleManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate  {


    var charact:CBCharacteristic!
    public var connectingPeripheral:CBPeripheral!
    var centralManager: CBCentralManager!

    private let UuidSerialService = "176ba416-a6ec-4b0f-a0a1-b8f6909b36d6"
    private let UuidTx =            "176ba416-a6ec-4b0f-a0a1-b8f6909b36d6"
    private let UuidRx =            "176ba416-a6ec-4b0f-a0a1-b8f6909b36d6"

    private var periphName = ""


    override init() {
        print("BleManager INIT!");
        super.init()
    }

    public func start(name:String) {
        self.periphName = name
        initCentral()
    }


    public func turnOn(id:String){
        if(charact != nil){
            let stValue =  id
            connectingPeripheral.writeValue(stValue.data(using: .utf8)!, for: charact, type: .withResponse)
        }
    }

    public func turnOff(id:String){
        if(charact != nil){
            let stValue =  "TURNOFF-" + id
            connectingPeripheral.writeValue(stValue.data(using: .utf8)!, for: charact, type: .withResponse)
        }
    }

    func initCentral() {
        print("Central launched!");
        centralManager = CBCentralManager(delegate: self, queue: nil,options: [CBCentralManagerOptionShowPowerAlertKey:true])
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "Bluetooth unknown"])
        case .resetting:
            print("central.state is .resetting")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "Bluetooth resetting"])
        case .unsupported:
            print("central.state is .unsupported")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "Bluetooth unsupported"])
        case .unauthorized:
            print("central.state is .unauthorized")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "Bluetooth unauthorized"])
        case .poweredOff:
            print("central.state is .poweredOff")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "Bluetooth is off"])
        case .poweredOn:
            print("central.state is .poweredOn")
            centralManager.scanForPeripherals(withServices: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if(peripheral.name == self.periphName){
            connectingPeripheral = peripheral
            connectingPeripheral.delegate = self
            centralManager.connect(connectingPeripheral, options: nil)
            centralManager.stopScan()
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "vistaBleMsg"), object: nil, userInfo : ["message": "connected"])
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected")
        centralManager.scanForPeripherals(withServices: nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if(peripheral.services?.count ?? 0 >= 1){
            peripheral.discoverCharacteristics(nil, for: peripheral.services!.first!)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let charactericsArr = service.characteristics
        {
            print(charactericsArr)
            charact = charactericsArr[1]
        }

        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Tx:
                if characteristic.uuid == CBUUID(string: UuidTx) {
                    charact = characteristic
                }

                // Rx:
                if characteristic.uuid == CBUUID(string: UuidRx) {
                    let rXcharacteristic = characteristic as CBCharacteristic
                    peripheral.setNotifyValue(true, for: rXcharacteristic)
                }
            }
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let rxData = characteristic.value
        if let rxData = rxData {
            let numberOfBytes = rxData.count
            var rxByteArray = [UInt8](repeating: 0, count: numberOfBytes)
            (rxData as NSData).getBytes(&rxByteArray, length: numberOfBytes)
            var res:String = "";
            for b in rxByteArray {
                let str = UnicodeScalar(b)
                res.unicodeScalars.append(str)
            }
            let splits = res.components(separatedBy: "|")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "onData"), object: nil, userInfo : ["action": splits[0]])
        }
    }
}
