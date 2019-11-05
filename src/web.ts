import { WebPlugin } from '@capacitor/core';
import { VistablePluginPlugin } from './definitions';

export class VistablePluginWeb extends WebPlugin implements VistablePluginPlugin {
  constructor() {
    super({
      name: 'VistablePlugin',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }

  async initManager(options: { apikey: string, name: string, connector: string }): Promise<any> {
    console.log('initManager', options);
    return options;
  }

  async turnOn(options: { win: String, second: String, third: String }): Promise<any> {
    console.log('turnOn', options);
    return options;
  }

  async turnOff(): Promise<any> {
    console.log('turnOff');
    return;
  }

}

const VistablePlugin = new VistablePluginWeb();

export { VistablePlugin };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(VistablePlugin);
