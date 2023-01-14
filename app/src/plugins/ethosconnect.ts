import { EthosConnectPlugin, EthosConfiguration } from "ethos-connect-vue";

export const ethosconnect = {
  EthosConnectPlugin,
  config: <EthosConfiguration>{
    hideEmailSignIn: true,
  },
};
