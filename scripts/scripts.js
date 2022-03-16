const hre = require("hardhat");
const { ethers } = require("hardhat");
const BoredApeNFTHolder = "0x1863b0B981E145f3974b21006D21F73D09813D10";
const BoredApeTokenAddress = "0x0ed64d01D0B4B655E410EF1441dD677B695639E7";
const StakeAddress = " 0xeCA1dD9BfA9Db6b85bbcBEf7C71A91652Ff16B2c";

async function main() {
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [BoredApeNFTHolder],
  });
  const BoredAppSigner = await ethers.getSigners(BoredApeNFTHolder);
  const stakingContract = await hre.ethers.getContractAt(
    "BoardStake",
    StakeAddress,
    BoredAppSigner
  );
  const BoredApeContract = await ethers.getContractAt(
    "IERC721",
    "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D"
  );
  const BoredApeTokenContract = await ethers.getContractAt(
    "IERC20",
    BoredApeTokenAddress
  );

  console.log(await BoredApeTokenContract.balanceOf(BoredApeNFTHolder));
  console.log(await BoredApeContract.balanceOf(BoredApeNFTHolder));
  const results = await stakingContract.stake(
    ethers.utils.parseUnits("1", 18)
  );
  const events = await results.wait();
  console.log(events);
  
  const resultsWithdraw = await stakingContract.withdraw();
  const eventsWithdraw = await resultsWithdraw.wait();
  console.log(eventsWithdraw);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
