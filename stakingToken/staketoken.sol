//bugs: https://forum.openzeppelin.com/t/request-example-of-how-to-withdraw-erc20-token/4256/5

pragma solidity ^0.6.10;

//pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/access/AccessControl.sol";
import "openzeppelin-solidity/contracts/GSN/Context.sol";


/**
 * @title Staking Token (STK)
 * @notice Implements a basic ERC20 staking token with incentive distribution.
 */
contract StakingToken is ERC20, Ownable, Context, AccessControl {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    bytes32 public constant WITHDRAWER_ROLE = keccak256("WITHDRAWER_ROLE");

    /**
     * @notice We usually require to know who are all the stakeholders.
     */
    address[] internal stakeholders;

    /**
     * @notice The stakes for each stakeholder.
     */
    mapping(address => uint256) internal stakes;

    /**
     * @notice The accumulated rewards for each stakeholder.
     */
    mapping(address => uint256) internal rewards;



    address public interest;


    constructor (string memory name, string memory symbol)
        ERC20(name, symbol)
        public
    {
        // Mint 100 tokens to msg.sender
        // Similar to how
        // 1 dollar = 100 cents
        // 1 token = 1 * (10 ** decimals)
        //_mint(msg.sender, 500000000 * 10 ** uint(decimals()));
        //interest = _interest
          _setupRole(WITHDRAWER_ROLE, _msgSender());
    }

    // ---------- STAKES ----------

    /**
     * @notice A method for a stakeholder to create a stake.
     * @param _stake The size of the stake to be created.
     */
    function createStake(uint256 _stake)
        public
    {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender] == 0) addStakeholder(msg.sender);
        stakes[msg.sender] = stakes[msg.sender].add(_stake);
    }

    /**
     * @notice A method for a stakeholder to remove a stake.
     * @param _stake The size of the stake to be removed.
     */
    function removeStake(uint256 _stake)
        public
    {
        stakes[msg.sender] = stakes[msg.sender].sub(_stake);
        if(stakes[msg.sender] == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    /**
     * @notice A method to retrieve the stake for a stakeholder.
     * @param _stakeholder The stakeholder to retrieve the stake for.
     * @return uint256 The amount of wei staked.
     */
    function stakeOf(address _stakeholder)
        public
        view
        returns(uint256)
    {
        return stakes[_stakeholder];
    }


    function GetStakes()
        public
        view
        returns(address[] memory _stakeholders, uint256[] memory _stakes)
    {
      uint256[] memory newstakes = new uint256[](stakeholders.length);
      for (uint256 s = 0; s < stakeholders.length; s += 1){
          newstakes[s]= stakes[stakeholders[s]];
      }
      return (stakeholders,newstakes);
    }


    function GetRewards()
        public
        view
        returns(address[] memory _stakeholders, uint256[] memory _rewards)
    {
      uint256[] memory newrewards = new uint256[](stakeholders.length);
      for (uint256 s = 0; s < stakeholders.length; s += 1){
          newrewards[s]= rewards[stakeholders[s]];
      }
      return (stakeholders,newrewards);
    }




    /**
     * @notice A method to the aggregated stakes from all stakeholders.
     * @return uint256 The aggregated stakes from all stakeholders.
     */
    function totalStakes()
        public
        view
        returns(uint256)
    {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
        }
        return _totalStakes;
    }

    // ---------- STAKEHOLDERS ----------

    /**
     * @notice A method to check if an address is a stakeholder.
     * @param _address The address to verify.
     * @return bool, uint256 Whether the address is a stakeholder,
     * and if so its position in the stakeholders array.
     */
    function isStakeholder(address _address)
        public
        view
        returns(bool, uint256)
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    /**
     * @notice A method to add a stakeholder.
     * @param _stakeholder The stakeholder to add.
     */
    function addStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

    /**
     * @notice A method to remove a stakeholder.
     * @param _stakeholder The stakeholder to remove.
     */
    function removeStakeholder(address _stakeholder)
        public
    {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    // ---------- REWARDS ----------

    /**
     * @notice A method to allow a stakeholder to check his rewards.
     * @param _stakeholder The stakeholder to check rewards for.
     */
    function rewardOf(address _stakeholder)
        public
        view
        returns(uint256)
    {
        return rewards[_stakeholder];
    }

    /**
     * @notice A method to the aggregated rewards from all stakeholders.
     * @return uint256 The aggregated rewards from all stakeholders.
     */
    function totalRewards()
        public
        view
        returns(uint256)
    {
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
        }
        return _totalRewards;
    }

    /**
     * @notice A simple method that calculates the rewards for each stakeholder.
     * @param _stakeholder The stakeholder to calculate rewards for.
     */
    function calculateReward(address _stakeholder)
        public
        view
        returns(uint256)
    {
        return stakes[_stakeholder] / 100;
    }

    function BatchStakeholderRewards(address[] memory _stakeholders, uint256[] memory  _rewards)
        public
        onlyOwner
    {

      for (uint256 s = 0; s < _stakeholders.length; s += 1){
          address stakeholder = stakeholders[s];
          uint256 reward = calculateReward(stakeholder);
          rewards[stakeholder] = rewards[stakeholder].add(reward);
      }
    }

    function Mint(address  recipient, uint256 amount)
        public
        onlyOwner
    {
      _mint(recipient, amount);
    }


    function Burn(uint256 amount)
        public
    {
      _burn(msg.sender, amount);
    }


    function SetInterestToken(address _interest)
        public
        onlyOwner
    {
        interest = _interest;
    }

    /**
     * @notice A method to distribute rewards to all stakeholders.
     */
    function distributeRewards()
        public
        onlyOwner
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            address stakeholder = stakeholders[s];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
    }

    /**
     * @notice A method to allow a stakeholder to withdraw his rewards.
     */
    function withdrawReward()
        public
    {
        uint256 reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        //_mint(msg.sender, reward);
        withdraw(interest,msg.sender, reward);
    }


    function withdraw(IERC20 token, address recipient, uint256 amount) public {
        require(hasRole(WITHDRAWER_ROLE, _msgSender()), "MyContract: must have withdrawer role to withdraw");
        token.safeTransfer(recipient, amount);
    }

}