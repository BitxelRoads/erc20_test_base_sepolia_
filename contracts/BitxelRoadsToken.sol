/**
  
     .------..------..------..------.
     |B.--. ||T.--. ||D.--. ||R.--. |
     | :/\: || (\/) || :(): || :/\: |
     | :\/: || :\/: || ()() || (__) |
     | '--'B|| '--'T|| '--'D|| '--'R|
     `------'`------'`------'`------'
                                       _.-="_-         _
                                  _.-="   _-          | ||"""""""---._______     __..
                      ___.===""""-.______-,,,,,,,,,,,,`-''----" """""       """""  __'
               __.--""     __        ,'                   o \           __        [__|
          __-""=======.--""  ""--.=================================.--""  ""--.=======:
         ]       [ ] : /        \ : |========================|    : /        \ :  [ ] :
         V___________:|     O    |: |========================|    :|     O    |:   _-"
          V__________: \        / :_|=======================/_____: \        / :__-"
          -----------'  "-____-"  `-------------------------------'  "-____-"

     ██████╗ ██╗████████╗██╗  ██╗███████╗██╗         ██████╗  ██████╗  █████╗ ██████╗ ███████╗
     ██╔══██╗██║╚══██╔══╝╚██╗██╔╝██╔════╝██║         ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔════╝
     ██████╔╝██║   ██║    ╚███╔╝ █████╗  ██║         ██████╔╝██║   ██║███████║██║  ██║███████╗
     ██╔══██╗██║   ██║    ██╔██╗ ██╔══╝  ██║         ██╔══██╗██║   ██║██╔══██║██║  ██║╚════██║
     ██████╔╝██║   ██║   ██╔╝ ██╗███████╗███████╗    ██║  ██║╚██████╔╝██║  ██║██████╔╝███████║
     ╚═════╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝

*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title BitxelRoadsToken
 * @dev Implementation of the Bitxel Roads Token (BTRD)
 */
contract BitxelRoadsToken is ERC20, Ownable, Pausable {
    // Constants
    uint256 public constant TOTAL_SUPPLY = 40_000_000_000 * (10**18);

    // State variables
    address public gameContract;
    address public vestingContract;

    // Events
    event GameContractUpdated(address indexed newGameContract);
    event VestingContractUpdated(address indexed newVestingContract);
    event TokensBurned(address indexed burner, uint256 amount);

    /**
     * @dev Modifier to restrict access to owner or game contract
     */
    modifier onlyGameOrOwner() {
        require(msg.sender == owner() || msg.sender == gameContract, "Not authorized");
        _;
    }

    /**
     * @dev Modifier for vesting contract operations
     */
    modifier onlyVesting() {
        require(msg.sender == vestingContract, "Only vesting contract");
        _;
    }

    /**
     * @dev Constructor that mints the initial supply to the deployer
     * @param initialOwner The address that will receive the initial supply
     */
    constructor(address initialOwner)
        ERC20("Bitxel Roads Token", "BTRD")
        Ownable(initialOwner)
    {
        _mint(initialOwner, TOTAL_SUPPLY);
    }

    /**
     * @dev Sets the game contract address
     * @param _gameContract The address of the game contract
     */
    function setGameContract(address _gameContract) 
        external 
        onlyOwner 
    {
        require(_gameContract != address(0), "Invalid game contract address");
        gameContract = _gameContract;
        emit GameContractUpdated(_gameContract);
    }

    /**
     * @dev Sets the vesting contract address
     * @param _vestingContract The address of the vesting contract
     */
    function setVestingContract(address _vestingContract) 
        external 
        onlyOwner 
    {
        require(_vestingContract != address(0), "Invalid vesting contract address");
        vestingContract = _vestingContract;
        emit VestingContractUpdated(_vestingContract);
    }

    /**
     * @dev Allows owner or game contract to burn tokens from any address
     * @param from The address from which to burn tokens
     * @param amount The amount of tokens to burn
     */
    function burnFrom(address from, uint256 amount)
        external
        onlyGameOrOwner
        whenNotPaused
    {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(from) >= amount, "Insufficient balance to burn");
        
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }

    /**
     * @dev Pauses all token transfers
     */
    function pause() 
        external 
        onlyOwner 
    {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers
     */
    function unpause() 
        external 
        onlyOwner 
    {
        _unpause();
    }

    /**
     * @dev Blocks renounceOwnership to ensure the contract always has an owner
     */
    function renounceOwnership() public virtual override onlyOwner {
        revert("Ownership cannot be renounced");
    }

    /**
     * @dev Override of the ERC20 transfer function to include pausable functionality
     */
    function transfer(address to, uint256 amount) 
        public 
        virtual 
        override 
        whenNotPaused 
        returns (bool) 
    {
        return super.transfer(to, amount);
    }

    /**
     * @dev Override of the ERC20 transferFrom function to include pausable functionality
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) 
        public 
        virtual 
        override 
        whenNotPaused 
        returns (bool) 
    {
        return super.transferFrom(from, to, amount);
    }

    /**
     * @dev Internal function to handle token transfers
     */
    function _update(
        address from,
        address to,
        uint256 value
    ) 
        internal 
        virtual 
        override 
    {
        require(!paused(), "Token transfers are paused");
        super._update(from, to, value);
    }
}
