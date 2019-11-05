#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(VistablePlugin, "VistablePlugin",
  CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(initManager, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(turnOn, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(turnOff, CAPPluginReturnPromise);
)
