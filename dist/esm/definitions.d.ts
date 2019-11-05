declare module "@capacitor/core" {
    interface PluginRegistry {
        VistablePlugin: VistablePlugin;
    }
}
export interface VistablePlugin {
    echo(options: any): Promise<any>;
    initManager(options: any): Promise<any>;
    turnOn(options: any): Promise<any>;
    turnOff(): Promise<any>;
}
