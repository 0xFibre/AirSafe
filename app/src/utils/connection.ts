import { ethos as ethosConnect } from "ethos-connect";
import { ethosForVue } from "ethos-connect-vue";

function getEthosVue() {
  return ethosForVue();
}

function isConnected() {
  const ethos = getEthosVue();
  return ethos.context?.wallet?.status === "connected";
}

function getConnectedWallet() {
  const ethos = getEthosVue();
  return ethos.context?.wallet;
}

function openModal() {
  ethosConnect.showSignInModal();
}

export const connection = { isConnected, openModal, getConnectedWallet };
