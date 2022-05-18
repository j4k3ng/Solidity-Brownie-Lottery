from brownie import Lottery
from scripts.deploy import get_account  
from web3 import Web3

def retrieve():
    lottery = Lottery[-1]
    account = get_account()
    value = Web3.toWei(0.006, "ether")
    lottery.retrieveEntryCondition({"from": account, "value": value})

def main():
    retrieve()