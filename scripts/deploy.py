from brownie import Lottery 
from brownie import accounts
from brownie import network
from brownie import config

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ['development', 'ganache-local']
def deploy_lottery():
    account = get_account()
    price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    lottery = Lottery.deploy(price_feed_address,{"from": account})
    print("Contract deployed to :", lottery.address)
    return lottery

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS: 
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])

def main():
    deploy_lottery()