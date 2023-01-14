export class Account {
  private _address: string;

  constructor(address: string) {
    this._address = address;
  }

  get address(): string {
    return this._address;
  }
}
