import {
  GetObjectDataResponse,
  isValidSuiObjectId,
  JsonRpcProvider,
  normalizeSuiObjectId,
  ObjectId,
  RpcProviderOptions,
} from "@mysten/sui.js";

export class Provider extends JsonRpcProvider {
  constructor(rpc: string, options?: RpcProviderOptions) {
    super(rpc, options);
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
