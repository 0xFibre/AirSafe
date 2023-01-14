import { WalletStandardAdapterProvider } from "@mysten/wallet-adapter-wallet-standard";
import { StandardWalletAdapter } from "@mysten/wallet-adapter-wallet-standard/dist/StandardWalletAdapter";
import { Account } from "./account";

interface MoveCallPayload {
  function: string;
  packageObjectId: string;
  module: string;
  typeArguments: string[];
  arguments: any[];
  gasBudget?: number;
}

export class Connection {
  private provider: WalletStandardAdapterProvider;
  private _connected: boolean;
  private _wallet?: StandardWalletAdapter;
  private _account?: Account;

  constructor() {
    this.provider = new WalletStandardAdapterProvider();
    this._connected = false;
  }

  get wallets() {
    const wallets = this.provider.get();
    return wallets.map((wallet) => ({ name: wallet.name, icon: wallet.icon }));
  }

  isConnected() {
    return !!this._connected;
  }

  async connect(walletName: string) {
    const wallets = this.provider.get();
    const wallet = wallets.find((wallet) => wallet.name === walletName);

    if (wallet) {
      await wallet.connect();

      const accounts = await wallet.getAccounts();
      this._account = new Account(accounts[0]);

      this._wallet = wallet;
      this._connected = true;
    }
  }

  async disconnect() {
    if (!this._connected) throw new Error("Wallet is not connected");

    await this._wallet?.disconnect();
    this._connected = false;
  }

  get account() {
    return this._account;
  }

  async executeMoveCall(payload: MoveCallPayload) {
    if (!this._connected) throw new Error("Wallet is not connected");

    let transaction = {
      data: {
        ...payload,
        gasBudget: payload.gasBudget || 30000,
      },
      kind: <"moveCall">"moveCall",
    };

    return await this._wallet?.signAndExecuteTransaction(transaction);
  }

  get wallet(): StandardWalletAdapter | undefined {
    return this._wallet;
  }
}
