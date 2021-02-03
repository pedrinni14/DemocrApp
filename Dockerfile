FROM ubuntu:latest
 # Get the Ethereum Stuffs
 RUN apt-get update
 RUN apt-get install -y software-properties-common
 RUN apt-get install -y build-essential
 RUN add-apt-repository ppa:longsleep/golang-backports
 RUN apt-get update
 RUN apt-get install -y git npm nodejs
 RUN apt-get install -y golang-go
 RUN apt-get install -y apache2
 RUN git clone https://github.com/ethereum/go-ethereum
 WORKDIR /go-ethereum
 RUN make geth
 WORKDIR /
 # House the data here
 RUN mkdir /block-data
 # Pass in the genesis block.
 COPY ./nodes/democrapp.json GenesisBlock.json
 RUN ln -sf /go-ethereum/build/bin/geth /bin/geth
 RUN service apache2 start
 EXPOSE 22 80 8088 50070 8545 30090 30303
 ENTRYPOINT geth --datadir /block-data init /GenesisBlock.json; geth --port 3000 --networkid 49402 --nodiscover --datadir=./block-data --maxpeers=0  --rpc  --rpcaddr 0.0.0.0 --rpcport 8545 --rpccorsdomain "*" --rpcapi "eth,net,web3,personal,miner"