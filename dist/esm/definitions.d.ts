declare module "@capacitor/core" {
    interface PluginRegistry {
        VistablePlugin: VistablePluginPlugin;
    }
}
export interface VistablePluginPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    initManager(options: {
        apikey: string;
        name: string;
        connector: string;
    }): Promise<{
        value: string;
    }>;
    turnOn(options: {
        win: String;
        second: String;
        third: String;
    }): Promise<{
        value: string;
    }>;
    turnOff(): Promise<{
        value: string;
    }>;
}
