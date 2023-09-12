# LedgerFi Token and Vesting Contract

There are two contracts in this repository. One is an LFT token contract that follows the ERC20 standard and the other is a vesting contract that holds tokens for stakeholders like the Team, community, investor, public sale, private sale, etc.

## 1. Vesting Contract
This contract holds and releases the pre-minted tokens for each stakeholder. The "VESTING" folder contains master contracts for vesting operations

### RoleControl.sol
The vestingMaster contract contains  functionalities that can only be performed with privileged roles. The RoleControl contract implements _Role.sol_ (from openzeppelin) for creating two privileged roles, one is the Owner role and the other is the Releaser role.  The roles are configured such that at an instant only one wallet can be Owner, but multiple wallets can act as the Releaser. The Owner is the account that owns the contract and has the privilege to assign tokens to vesting-team members.Wallet address with releasers role have the privilege to release tokens to team members' account. The contract contains getter functions that return active and inactive accounts within the owner/releaser role. 
### VestingMaster.sol

The contract in _VestingMaster.sol_ is the master contract that imports _VestingStorage.sol_ via _RoleControl.sol_ contract. The "VestingMaster" contract imports and creates child contracts for each stakeholder vesting. For example, the child contract for the "TEAM" vesting is created as _VestingTeam.sol_. Similarly, child contracts for other stakeholders are created, with only the parameter values differing between them.

The VestingMaster.sol contract has functions such as:

- IERC20address() for assigning LFT address to "_token"
- assignToken() function assigns a specified amount of tokens to the Member, but it only tracks the allocation and does not actually allocate tokens to the Member's real wallet. The tokens remain within the contract until the vesting time is reached.
- getTokenInfo() to retrieve information about token allocation and release into wallets.
- release() the function is called by the owner in particular intervals (TBD). The function iterates through each member in memberAddress and releases tokens if the vesting period is reached.
- getBalanceTokenForAssignment()- returns total amount of unassigned token in a vesting contract

### _VestingStorage.sol
The _VestingStorage.sol_ contract contains all state variables required for vesting. It includes:

- IERC20 _token - hold the address of LFT token contract
- membersAddress - holds wallet addresses of members to whom tokens are assigned.
- totalNumberVesting - total vesting periods
- vestingTime- Unix time stamp which represents each vesting time. Tokens will be released to the actual member wallet based on this vesting time.
- vestingPercentage - Value is taken as a percentage. Each value corresponds to each vesting time. Only the given percentage of tokens can be released to the member's real wallet when the respective vesting time is reached.
- teamMember- it is a mapping which tracks the total tokens assigned and released against each member wallet.
- onwners - hold the accounts that is having the Owner role in an active or inactive state
- releasers- hold the accounts that is having the Releaser role in an active or inactive state

_totalNumberVesting_ , _vestingTime_ and _vestingPercentage_ are initialsed in the proxy contract 

### VestingTeam.sol
The _VestingTeam.sol_ contract is an upgradable child contract of the VestingMaster contract, using _VestingTeamProxy.sol_. 

### VestingTeamproxy.sol
The _VestingTeamproxy.sol_ contract is the proxy for the VestingTeam contract, with its address used for TEAM vesting activities. The fallback function allows calling functions in the VestingTeam contract from the VestingTeamProxy.

The proxy contract intialises all state variables in vestingTeamStorage.
 
- vestingTeamaddress -  the contract address of vestingTeam. With fallback function, proxy contract execute functions in vestingTeam contract. 
- _vestingTime -  vesting time for TEAM is given as UNIX timestamp 
- _vestingPercentage-  vesting percentage for TEAM corresponding to each timestamp   
- _totalNumberVesting - total number of vesting
- updateContractAddress() - function which is used in proxy to change the main contract address(vestingTeamaddress).

## 2. LedgerFiToken
(Files in the folder TOKEN are of LFT token)
### LedgerFiTokenStorage.sol
The main contract of LFT token is in  _LedgerFiToken.sol_, which imports ERC20Burnable contract. All state variables are created and intialised in _LedgerFiTokenStorage.sol_


- maxSupply - holds the max supply of token ,for LFT its 500000000 (500 millions) tokens

- preMinedToken-  the value shows the total number of tokens that need to be pre-minted for different stakeholders (like advisors, investors, team, private Sale, public Sale etc.).  Fixed  percentages of preMinedToken will be minted for each stakeholder group(like advisors,investors, team, private Sale, public Sale etc.). 


#### Vesting Contract addresses

The below-given addresses are the vesting contract address related to each stakeholder (like Team, Advisor, SeedSale, etc). On the deployment of LFT tokens, predefined percentages of pre-minted token (preMinedToken) are assigned to these contract addresses. (Currently dummy value is given)

```
vestingTeamAddress ,vestingAdvisorsAddress, vestingSeedSaleAddress ,,vestingCommunityAddress , vestingMarketingAddress, vestingEcosystemAddress  , vestingPMLAddress
```


#### Vesting Percentage

The below given percentages indicates the vesting percentage of each stakeholders

```
vestingTeamPercent ,vestingAdvisorsPercent ,vestingSeedSalePercent, vestingPublicSalePercent, vestingCommunityPercent ,vestingMarketingPercent ,vestingEcosystemPercent ,vestingExchangePercent ,vestingPMLPercent 
```

- burnTokenAddress- Contract address which holds unallocated token that to be burned

- burnThreshold- This data is used after integrating the LFT minting triggers with,  LedgerMail and LedgerChat.  In tokenomics, when tokens are awarded to users as a reward for sending mail, some tokens may not be allocated. These tokens will be moved to  the _burnTokenAddress_  contract by invoking the _addBurnTokenCount_  function and will be burned when the contract balance reaches the _burnThreshold_

### RoleControl.sol
The LedgerFi contract contains few functionalities that can only be performed with privileged roles. The RoleControl contract implements _Role.sol_ (from openzeppelin) for creating two privileged roles, one is the Owner role and the other is the minterBurner role.  The roles are configured such that at an instant only one wallet can be Owner, but multiple wallets can act as the minterBurner. The Owner is the account that owns the contract and has right to premine token to vesting contract. Only the account with minterBurner role can call minting and burning funtion in LedgerFi contract. The contract contains getter functions that return active and inactive accounts within the owner/releaser role. ### LedgerFiToken.sol

The main contract of LFT token is in  _LedgerFiToken.sol_, which imports ERC20Burnable contract. All state variables are created and intialised in _LedgerFiTokenStorage.sol_

- mintVesting() - which mint the given percentage of tokens into vesting contracts corresponding to each stakeholder. 
- mint() for minting the given amount of token into the given address. This will be used after integrating LFT with LedgerMail. User rewards are minted with this.
- addBurnTokenCount -   the unallocated tokens are minted to the  _burnTokenAddress_ contract by calling this function and those allocated tokens will be burned when the balance reaches _burnThreshold_

