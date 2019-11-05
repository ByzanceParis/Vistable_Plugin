declare module "@capacitor/core" {
  interface PluginRegistry {
    VistablePlugin: VistablePluginPlugin;

  }
}

export interface VistablePluginPlugin {

  echo(options: any): Promise<any>;

  initManager(options: any): Promise<any>;

  turnOn(options: any): Promise<any>;

  turnOff(): Promise<any>;

}
