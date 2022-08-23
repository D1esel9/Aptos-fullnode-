sudo apt update && sudo apt upgrade -y

sudo apt-get install ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y

mkdir -p ~/.docker/cli-plugins/

curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose

chmod +x ~/.docker/cli-plugins/docker-compose

sudo chown $USER /var/run/docker.sock

mkdir ~/testnet && cd ~/testnet

wget -qO docker-compose.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose-fullnode.yaml

wget -qO fullnode.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/fullnode.yaml

nano fullnode.yaml

Меняем <Validator IP Address> на IP валидатора

Заходим на сервер валидатора в папку .aptos и копируем файлы genesis.blob waypoint.txt и папку keys на сервер фул ноды в папку testnet

На фул ноде вводим

docker compose up -d

Заходим на сервер валидатора, меняем данные ### на свои

/usr/local/bin/aptos genesis set-validator-configuration \
    --local-repository-dir $HOME/.aptos \
    --username ###ИМЯ НОДЫ### \
    --owner-public-identity-file $HOME/.aptos/keys/public-keys.yaml \
    --validator-host ###АЙПИ ВАЛИДАТОРА###:6180 \
    --full-node-host ###АЙПИ ФУЛНОДЫ###:6182 \
    --stake-amount 100000000000000

cd .aptos

docker compose restart

Проверка логов и синхры на фул ноде

docker logs -f testnet-fullnode-1 --tail 50

curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version | grep type

https://node.aptos.zvalid.com/
