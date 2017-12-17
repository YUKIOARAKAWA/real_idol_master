const IdolContract = artifacts.require('IdolContract.sol');

contract('IdolContract', (accounts) => {
  it('should be deployed and set idol for IdolTest', async function () {
    const name = "hirosesuzu";
    const issuance = 5;

    idolcontract = await IdolContract.new();
    await idolcontract.setIdol(name, issuance);
    const first_idol = await idolcontract.getIdol(0);

    assert.strictEqual(first_idol[0], name, 'Not correct set name!');
    assert.strictEqual(first_idol[1].toNumber(), issuance, 'Not correct set issuance!')
  });
});
