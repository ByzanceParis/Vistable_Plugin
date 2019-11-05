import { WebPlugin } from '@capacitor/core';
import { VistablePluginPlugin } from './definitions';
export declare class VistablePluginWeb extends WebPlugin implements VistablePluginPlugin {
    constructor();
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    initManager(options: {
        apikey: string;
        name: string;
        connector: string;
    }): Promise<any>;
    turnOn(options: {
        win: String;
        second: String;
        third: String;
    }): Promise<any>;
    turnOff(): Promise<any>;
}
declare const VistablePlugin: VistablePluginWeb;
export { VistablePlugin };
