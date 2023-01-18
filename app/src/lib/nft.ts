import { env } from "@/config";
import { Coin, getMoveObjectType, getObjectFields, getObjectId, SuiMoveObject, SuiObject } from "@mysten/sui.js";
import { Provider } from "./provider";
import { Nft } from "./types";

const provider = new Provider(env.suiRpcUrl);

function isNft(object: SuiObject) {
  // @ts-expect-error
  const fields = getObjectFields(object);
  return !!fields?.url && !!fields?.description;
}

async function getAddressNfts(address: string): Promise<Nft[]> {
  const objects = await provider.getObjectsOwnedByAddress(address);

  const objectIds = [];
  for (let i = 0; i < objects.length; i++) {
    const object = objects[i];
    if (!Coin.isCoin(object)) {
      objectIds.push(getObjectId(object));
    }
  }

  const batchObjects = await provider.getObjectBatch(objectIds);
  const nfts: Nft[] = [];

  for (let i = 0; i < batchObjects.length; i++) {
    const object = batchObjects[i];
    const fields = getObjectFields(object);

    // @ts-expect-error
    if (isNft(object.details)) {
      nfts.push({
        id: getObjectId(object),
        name: fields?.name,
        description: fields?.description,
        url: parseUrl(fields?.url),
        type: getMoveObjectType(object)!,
      });
    }
  }

  return nfts;
}

async function getNft(id: string): Promise<Nft> {
  const object = await provider.getObject(id);

  const fields = getObjectFields(object);

  // @ts-expect-error
  if (nft.isNft(object.details)) {
    return {
      id: getObjectId(object),
      name: fields?.name,
      description: fields?.description,
      url: nft.parseUrl(fields?.url),
      type: getMoveObjectType(object)!,
    };
  }

  throw new Error("");
}

function parseUrl(url: string) {
  return url.startsWith("ipfs://") ? url.replace("ipfs://", "https://ipfs.io/ipfs/") : url;
}

export const nft = { getAddressNfts, parseUrl, getNft, isNft };
