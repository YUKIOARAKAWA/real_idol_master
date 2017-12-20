const IdolContract = artifacts.require('IdolContract.sol');
const user_id = 1;
const idol_name = "hirosesuzu";
const issuance = 5;

contract('IdolContract', (accounts) => {

  before (async () => {
    idolcontract = await IdolContract.new();
  });

  it('should be deployed and set idol for IdolTest', async function () {

    // idolcontract = await IdolContract.new();
    await idolcontract.setIdol(idol_name, issuance);
    const first_idol = await idolcontract.getIdol(1);

    assert.strictEqual(first_idol[0], idol_name, 'Not correct set idol_name!');
    assert.strictEqual(first_idol[1].toNumber(), issuance, 'Not correct set issuance!');
  });

  it('should be correct check idol existence', async function () {
    const existence_target_id = 1;
    const notexistence_traget_id = 2;

    const check_result0 = await idolcontract.checkIdolExistence(existence_target_id);
    // checkIdolExistence functionでissuanceを減らそうとすると、function がconstantではダメ
    // しかし、constantを外すと、return でトランザクションの情報が返ってくる...
    // そこで、checkIdolExistenceとは別にdecreaseIssuance functionを定義して、そこでissuanceを-1する
    const registered_id = await idolcontract.decreaseIssuance(existence_target_id, user_id);

    const first_idol = await idolcontract.getIdol(1);

    assert.strictEqual(check_result0, true, 'Not correct check result');
    assert.strictEqual(first_idol[1].toNumber(), issuance - 1, 'Not correct issuance');


    const check_result1 = await idolcontract.checkIdolExistence(notexistence_traget_id);
    assert.strictEqual(check_result1, false, 'Not corrrect result');
  });

  it('should be add new idol information', async function () {
    const idol_name = "sasakiayaka";
    const issuance = 1;

    await idolcontract.setIdol(idol_name, issuance);
    const second_idol = await idolcontract.getIdol(2);

    assert.strictEqual(second_idol[0], idol_name, 'Not correct set idol_name!');
    assert.strictEqual(second_idol[1].toNumber(), issuance, 'Not correct set issuance!');

    const check_result1 = await idolcontract.checkIdolExistence(1);
    assert.strictEqual(check_result1, true, 'Not correct result!');
  });
});
