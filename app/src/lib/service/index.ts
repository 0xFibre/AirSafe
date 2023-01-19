import { env } from "@/config";
import { SafeService } from "./Safe";

const safeServiceData = {
  packageObjectId: env.airsafePackageId,
  registryObjectId: env.safeRegistryId,
  rpcUrl: env.suiRpcUrl,
};

export const safeService = new SafeService(safeServiceData);
