const hre = require("hardhat");

async function main() {
  // Dirección del contrato desplegado
  const CONTRACT_ADDRESS = "0x8bbba4b076916BFE4dCC19aDc797F2682E8DFd08";
  
  // Obtener el contrato
  const BitxelRoadsToken = await hre.ethers.getContractFactory("BitxelRoadsToken");
  const token = await BitxelRoadsToken.attach(CONTRACT_ADDRESS);

  console.log("Iniciando pruebas del contrato desplegado...");

  // 1. Verificar información básica
  const name = await token.name();
  const symbol = await token.symbol();
  const totalSupply = await token.totalSupply();
  const decimals = await token.decimals();

  console.log(`
    Información del Token:
    - Nombre: ${name}
    - Símbolo: ${symbol}
    - Supply Total: ${totalSupply}
    - Decimales: ${decimals}
  `);

  // 2. Obtener el balance del deployer
  const [deployer] = await hre.ethers.getSigners();
  const balance = await token.balanceOf(deployer.address);
  console.log(`Balance del deployer: ${balance}`);

  // 3. Crear una dirección de prueba para transferencias
  const testAddress = "0x1234567890123456789012345678901234567890";
  
  try {
    // 4. Probar transfer
    console.log("Probando transfer...");
    const transferAmount = hre.ethers.parseEther("1000");
    await token.transfer(testAddress, transferAmount);
    console.log(`Transferidos ${transferAmount} tokens a ${testAddress}`);

    // 5. Probar approve
    console.log("Probando approve...");
    const approveAmount = hre.ethers.parseEther("500");
    await token.approve(testAddress, approveAmount);
    console.log(`Aprobados ${approveAmount} tokens para ${testAddress}`);

    // 6. Probar pause
    console.log("Probando pause...");
    await token.pause();
    console.log("Contrato pausado");

    // 7. Probar unpause
    console.log("Probando unpause...");
    await token.unpause();
    console.log("Contrato despausado");

    // 8. Probar burnFrom
    console.log("Probando burnFrom...");
    const burnAmount = hre.ethers.parseEther("100");
    await token.burnFrom(deployer.address, burnAmount);
    console.log(`Quemados ${burnAmount} tokens`);

  } catch (error) {
    console.error("Error durante las pruebas:", error);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  }); 