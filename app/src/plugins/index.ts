import type { App } from "vue";

import { vuetify } from "./vuetify";
import { pinia } from "../store";
import { router } from "../router";
import { Toast } from "./toast";

export function registerPlugins(app: App) {
  app.use(vuetify).use(router).use(pinia).use(Toast);
}
