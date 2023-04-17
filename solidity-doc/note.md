<style>
r { color: Red }
o { color: Orange }
g { color: Green }
</style>

# TODOs:

- <r>TODO:</r> Important thing to do
- <o>TODO:</o> Less important thing to do
- <g>DONE:</g> Breath deeply and improve karma

# hardhat

Use >npx hardhat if you installed hardhat local: > yarn add --dev hardhat
start:
>npx hardhat

- compile contract(default it compiles the contracts folder):
> npx hardhat compile

- test
> npx hardhat test

- deploy
> npx hardhat run scripts/deploy.ts [--network localhost]

# ethers

> const Lock = await ethers.getContractFactory("Lock)
> const lock = await Lock.deploy("1668989898", { value: ethers.utils.parseEther("0.001")})
> lock
> await lock.owner()
> await lock.unlockTime()
> await lock.withdraw()