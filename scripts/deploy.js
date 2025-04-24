const hre = require("hardhat");

async function main() {
  try {
    console.log("Starting deployment to Base Sepolia...");

    // Get the deployer's address
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    // Check deployer balance
    const balance = await ethers.provider.getBalance(deployer.address);
    console.log("Account balance:", ethers.formatEther(balance), "ETH");

    // Get the contract factory
    const BitxelRoadsToken = await ethers.getContractFactory("BitxelRoadsToken");
    
    // Deploy the contract
    console.log("Deploying BitxelRoadsToken...");
    const token = await BitxelRoadsToken.deploy(deployer.address);
    
    // Wait for deployment
    await token.waitForDeployment();

    // Get the deployed contract address
    const tokenAddress = await token.getAddress();
    console.log("BitxelRoadsToken deployed to:", tokenAddress);

    // Wait for more confirmations
    console.log("Waiting for 5 block confirmations...");
    const receipt = await token.deploymentTransaction().wait(5);
    console.log("Deployment confirmed in block:", receipt.blockNumber);

    // Verify the contract on Basescan
    if (process.env.BASESCAN_API_KEY) {
      console.log("Starting contract verification on Basescan...");
      try {
        await hre.run("verify:verify", {
          address: tokenAddress,
          constructorArguments: [deployer.address],
        });
        console.log("Contract verified on Basescan");
      } catch (error) {
        console.log("Verification error:", error.message);
      }
    }

    // Log deployment info
    console.log("\nDeployment Summary:");
    console.log("-------------------");
    console.log("Network:", network.name);
    console.log("Token Address:", tokenAddress);
    console.log("Owner Address:", deployer.address);
    
    // Additional deployment info
    const totalSupply = await token.totalSupply();
    console.log("Total Supply:", ethers.formatEther(totalSupply), "BTRD");
    
    // Save deployment info to a file
    const fs = require("fs");
    const deploymentInfo = {
      network: network.name,
      tokenAddress: tokenAddress,
      owner: deployer.address,
      deploymentDate: new Date().toISOString(),
      totalSupply: ethers.formatEther(totalSupply)
    };
    
    fs.writeFileSync(
      'deployment-sepolia-info.json',
      JSON.stringify(deploymentInfo, null, 2)
    );
    console.log("\nDeployment info saved to deployment-sepolia-info.json");
    
  } catch (error) {
    console.error("Error during deployment:", error);
    process.exit(1);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 