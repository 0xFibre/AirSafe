import {
  GetObjectDataResponse,
  isValidSuiObjectId,
  JsonRpcProvider,
  normalizeSuiObjectId,
  ObjectId,
  RpcProviderOptions,
} from "@mysten/sui.js";
import { DynamicFieldInfo } from "./types";

export class Provider extends JsonRpcProvider {
  constructor(rpc: string, options?: RpcProviderOptions) {
    super(rpc, options);
  }

  async getDynamicFields(
    objectId: ObjectId,
    cursor: ObjectId | null = null,
    limit: number | null = null
  ): Promise<DynamicFieldInfo[]> {
    try {
      if (!objectId || !isValidSuiObjectId(normalizeSuiObjectId(objectId))) {
        throw new Error("Invalid Sui Object id");
      }
      if (cursor && !isValidSuiObjectId(normalizeSuiObjectId(objectId))) {
        throw new Error("Invalid cursor");
      }

      const response = await this.client.request("sui_getDynamicFields", [
        objectId,
        cursor,
        limit,
      ]);

      return response.result.data;
    } catch (err) {
      throw new Error(
        `Error fetching dynamic fields: ${err} for id ${objectId}`
      );
    }
  }

  async getDynamicFieldObject(
    objectId: ObjectId,
    name: string
  ): Promise<GetObjectDataResponse> {
    try {
      if (!objectId || !isValidSuiObjectId(normalizeSuiObjectId(objectId))) {
        throw new Error("Invalid Sui Object id");
      }

      return await this.client.requestWithType(
        "sui_getDynamicFieldObject",
        [objectId, name],
        GetObjectDataResponse,
        this.options.skipDataValidation
      );
    } catch (err) {
      throw new Error(
        `Error fetching dynamic fields: ${err} for id ${objectId}`
      );
    }
  }
}
