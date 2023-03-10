interface Env {
  safeRegistryId: string;
  airsafePackageId: string;
  suiRpcUrl: string;
  suiExplorerUrl: string;
  suiNetwork: string;
}

const environment = import.meta.env;

export const env: Env = {
  safeRegistryId: environment.VITE_SAFE_REGISTRY_ID,
  airsafePackageId: environment.VITE_AIRSAFE_PACKAGE_ID,
  suiRpcUrl: environment.VITE_SUI_RPC_URL,
  suiExplorerUrl: environment.VITE_SUI_EXPLORER_URL,
  suiNetwork: environment.VITE_SUI_NETWORK,
};
