import "@mdi/font/css/materialdesignicons.css";
import "vuetify/styles";

import { createVuetify } from "vuetify";

export const vuetify = createVuetify({
  theme: {
    themes: {
      light: {
        colors: {
          primary: "#0d4fe8",
          secondary: "#5CBBF6",
          background: "#f3f3f3",
        },
      },
    },
  },
});
