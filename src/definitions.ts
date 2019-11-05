// declare module "@capacitor/core" {
//   interface PluginRegistry {
//     VistablePlugin: VistablePlugin;
//   }
// }

declare global {
  interface VistablePlugin {
    VistablePlugin?: VistablePlugin;
  }
}

export interface VistablePlugin {

  echo(options: any): Promise<any>;

  initManager(options: any): Promise<any>;

  turnOn(options: any): Promise<any>;

  turnOff(): Promise<any>;

}
