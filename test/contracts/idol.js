const IdolContract = artifacts.require('IdolContract.sol');

contract('IdolContract', (accounts) => {

  before (async () => {
    idolcontract = await IdolContract.new();
  });

  it('should be deployed and set idol for IdolTest', async function () {
    const name = "hirosesuzu";
    const issuance = 5;

    // idolcontract = await IdolContract.new();
    await idolcontract.setIdol(name, issuance);
    const first_idol = await idolcontract.getIdol(0);

    assert.strictEqual(first_idol[0], name, 'Not correct set name!');
    assert.strictEqual(first_idol[1].toNumber(), issuance, 'Not correct set issuance!')
  });

  it('should be correct check idol existence', async function () {
    const existence_target_id = 0;
    const notexistence_traget_id = 1;

    const check_result0 = await idolcontract.checkIdolExistence(existence_target_id);
    assert.strictEqual(check_result0, true, 'Not correct check result');

    const check_result1 = await idolcontract.checkIdolExistence(notexistence_traget_id);
    assert.strictEqual(check_result1, false, 'Not corrrect result');
  });
});
