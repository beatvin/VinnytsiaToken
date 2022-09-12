var IterableMapping = artifacts.require("IterableMapping");
var VinnytsiaToken = artifacts.require("VinnytsiaToken");

module.exports = function(deployer) {

  deployer.deploy(IterableMapping);

  deployer.link(IterableMapping,VinnytsiaToken);

  deployer.deploy(VinnytsiaToken);
  
};