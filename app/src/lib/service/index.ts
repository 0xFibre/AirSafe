import { env } from "@/config";
import { SafeService } from "./Safe";

const safeServiceData = {
  packageObjectId: env.valletPackageId,
  registryObjectId: env.safeRegistryId,
  rpcUrl: env.suiRpcUrl,
};

export const safeService = new SafeService(safeServiceData);
