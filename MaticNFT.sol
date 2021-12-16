// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MaticNFT is ERC721 {
    uint private tokenCounter = 0;
    uint private randNonce = 0;

    string private _baseURIextended = "https://ipfs.io/ipfs/";
    string private normalMaticUri = "QmcEU3auA9JtLVpkNfKee1fSCRnmc5ozDKa3y33hhsxs56";
    string private greenMaticUri = "QmbUBm6udYNiVKWoencZaXPXc2REJo5LdzfmEcmoS3HWXv";
    string private rainbowMaticUri = "QmRAsRWnuKgi9Cx1QG4DXNTRuYg4a3FbBgoC2qqch3RUa9";
    mapping (uint256 => string) private _tokenURIs;


    constructor() ERC721("maticNFT", "MATIC") {}

    function convertToNFT() public payable returns (uint) {
        require(msg.value == 10**18, "Send value should be 1 matic!");
        tokenCounter ++;
        mintNFT(msg.sender, tokenCounter);
        return tokenCounter;
    }
    function convertToMatic(uint tokenId) public {
        require(ownerOf(tokenId) == msg.sender);
        _burn(tokenId);
        payable(msg.sender).transfer(10**18);
    }
    function mintNFT(
            address _to,
            uint256 _tokenId
        ) internal {
            _mint(_to, _tokenId);
            uint randomNum = randMod(100);
            if (randomNum <= 50 ){
                _setTokenURI(_tokenId, normalMaticUri);
            } else if (50 < randomNum && randomNum <= 90) {
                _setTokenURI(_tokenId, greenMaticUri);
            } else {
                _setTokenURI(_tokenId, rainbowMaticUri);
            }
    }
    function randMod(uint _modulus) internal returns(uint) {
        randNonce++;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % _modulus;
    }
    function getTotalSupply () public view returns (uint) {
        return address(this).balance;
    }

    // ERC721 override for tokenURIs
    function _baseURI() internal view virtual override returns (string memory) {
            return _baseURIextended;
    }
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
            require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
            _tokenURIs[tokenId] = _tokenURI;
    }
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        return string(abi.encodePacked(base, _tokenURI));
    }
}
