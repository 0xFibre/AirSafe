import type { App } from "vue";

import { loadFonts } from "./webfontloader";
import { vuetify } from "./vuetify";
import pinia from "../store";
import router from "../router";
import { ethosconnect } from "./ethosconnect";

export function registerPlugins(app: App) {
  loadFonts();
  app
    .use(vuetify)
    .use(router)
    .use(pinia)
    .use(ethosconnect.EthosConnectPlugin, ethosconnect.config);
}
