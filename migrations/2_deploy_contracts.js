const Token = artifacts.require("ERC20");
const Manager = artifacts.require("Manager");
const Vest = artifacts.require("Vesting");
const Advisor = artifacts.require("AdvisorManager");
const MSW1 = artifacts.require("MultisigWallet");
const MSW2 = artifacts.require("MultisigWallet_2");
const MSW3 = artifacts.require("MultisigWallet_3");
const MSW4 = artifacts.require("MultisigWallet_4");
const MSW5 = artifacts.require("MultisigWallet_5");


salesWallet="0x7eAE698d28f57B1B8604bf2CF7a68F14da943e91"

const sleep = ms => new Promise(res => setTimeout(res, ms));
module.exports = async function(deployer) {
	await deployer.deploy(Token,'x','x')
    TokenInstance = await Token.deployed()
    
    
    await deployer.deploy(Manager, Token.address)
    ManagerInstance = await Manager.deployed()
    
    await deployer.deploy(Vest, Token.address)
    VestInstance = await Vest.deployed()
    
    await deployer.deploy(Advisor, Vest.address,Manager.address,Token.address)
    AdvisorInstance = await Advisor.deployed()



    await TokenInstance.mint(Manager.address)
    await TokenInstance.renounceOwnership()



    
    await deployer.deploy(MSW1,"0xbA8101599D42Ce075AeC34e4526F06C0D8440723",
        "0xBf88Ec05aDcd9CD0960325Ac3ec56997BD5A940d",
        "0xA9242D61BF2792154a65A0D96e9FE6884E8Cd1D2",3)
    MSW1Instance = await MSW1.deployed()
    
    await deployer.deploy(MSW2,"0xbA8101599D42Ce075AeC34e4526F06C0D8440723",
        "0xBf88Ec05aDcd9CD0960325Ac3ec56997BD5A940d",
        "0xA9242D61BF2792154a65A0D96e9FE6884E8Cd1D2",3)
    MSW2Instance = await MSW2.deployed()
    
    await deployer.deploy(MSW3,"0xbA8101599D42Ce075AeC34e4526F06C0D8440723",
        "0xBf88Ec05aDcd9CD0960325Ac3ec56997BD5A940d",
        "0xA9242D61BF2792154a65A0D96e9FE6884E8Cd1D2",3)
    MSW3Instance = await MSW3.deployed()
    
    await deployer.deploy(MSW4,"0xbA8101599D42Ce075AeC34e4526F06C0D8440723",
        "0xBf88Ec05aDcd9CD0960325Ac3ec56997BD5A940d",
        "0xA9242D61BF2792154a65A0D96e9FE6884E8Cd1D2",3)
    MSW4Instance = await MSW4.deployed()
    
    await deployer.deploy(MSW5,"0xbA8101599D42Ce075AeC34e4526F06C0D8440723",
        "0xBf88Ec05aDcd9CD0960325Ac3ec56997BD5A940d",
        "0xA9242D61BF2792154a65A0D96e9FE6884E8Cd1D2",3)
    MSW5Instance = await MSW5.deployed()
    
    await AdvisorInstance.transferOwnership(MSW4.address)
    
    await ManagerInstance.setFaction("SeedSale",salesWallet,"35000000000000000000000000")
    await ManagerInstance.setFaction("PrivateSale",salesWallet,"145000000000000000000000000")
    await ManagerInstance.setFaction("PublicSale",salesWallet,"10000000000000000000000000")
    await ManagerInstance.setFaction("Growth",MSW1.address,"380000000000000000000000000")
    await ManagerInstance.setFaction("Liquidity",MSW2.address,"122000000000000000000000000")
    await ManagerInstance.setFaction("MarketingLegal",MSW3.address,"98000000000000000000000000")
    await ManagerInstance.setFaction("Advisors",Advisor.address,"60000000000000000000000000")
    await ManagerInstance.setFaction("Team",MSW5.address,"150000000000000000000000000")
    await sleep(20000)
    await ManagerInstance.renounceOwnership()
    






















	
};
