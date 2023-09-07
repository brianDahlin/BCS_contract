// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721A, ERC721ABurnable, IERC721A} from "../lib/ERC721ABurnable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract PlayerNFTs is ERC721A, ERC721ABurnable, Ownable {
    using Strings for uint256;

    uint256 public price;
    uint256 public privateSupply;
    uint256 public maxSupply;
    uint256 public maxPerTx;

    uint256 public claimedPrivateNfts;

    string private baseURI;

    bool public mintEnabled;

    // mapping(address => bool) public claimed;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 price_,
        uint256 privateSupply_,
        uint256 maxPerTx_,
        uint256 maxSupply_,
        address owner_
        ) ERC721A(name_, symbol_) 
    {
        setBaseURI("ipfs://testesttest/");
        price = price_;
        privateSupply = privateSupply_;
        maxPerTx = maxPerTx_;
        maxSupply = maxSupply_;
        transferOwnership(owner_);
    }

    function mint(uint256 amount) external payable {
        require(msg.value >= price, "Please send the exact amount");
        require(totalSupply() + amount <= maxSupply, "No more");
        require(mintEnabled, "Minting is not live yet");
        require(amount <= maxPerTx, "Amount to mint should be lower");

        _safeMint(msg.sender, amount);
    }

    function claimPrivateSupply(address to, uint256 amount) external onlyOwner {
        require(claimedPrivateNfts + amount <= privateSupply, "Not enough private supply to mint");
        claimedPrivateNfts += amount;
        _safeMint(to, amount);
    }

    function flipSale() external onlyOwner {
        require(totalSupply() >= privateSupply, "Mint private supply first");
        mintEnabled = !mintEnabled;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721A, IERC721A)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
    }

    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    function setPrice(uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function withdraw() external onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Transfer failed.");
    }
}