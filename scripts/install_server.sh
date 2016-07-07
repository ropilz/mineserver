#! /bin/bash

if [ -z $1 ]
then
  echo "specify server name"
  exit
fi

server_config_path="$PWD/servers/$1"

if [ ! -f "$server_config_path" ]
then
    echo "invalid server name!"
    exit
fi

. $server_config_path

mkdir -p "../server/$server_name"
cd "../server/$server_name"

# install server
wget "http://files.minecraftforge.net/maven/net/minecraftforge/forge/$forge_version/forge-$forge_version-installer.jar"
java -jar "forge-$forge_version-installer.jar" --installServer
java -jar "forge-$forge_version-universal.jar"

count=0
cd mods
while [ "x${mod[count]}" != "x" ]
do
  wget ${mod[count]}
   count=$(( $count + 1 ))
done
cd ..

sed -i "" -e 's/false/true/' eula.txt
echo "\
#Minecraft server properties
#Wed Jul 06 21:20:47 BOT 2016
generator-settings=
op-permission-level=4
allow-nether=true
level-name=world
enable-query=false
allow-flight=false
announce-player-achievements=true
server-port=25565
level-type=DEFAULT
enable-rcon=false
force-gamemode=false
level-seed=
server-ip=
max-build-height=256
spawn-npcs=true
white-list=false
spawn-animals=true
snooper-enabled=true
hardcore=false
online-mode=$online_mode
resource-pack=
pvp=$pvp
difficulty=1
server-name=twilight
enable-command-block=false
player-idle-timeout=0
gamemode=0
max-players=20
spawn-monsters=true
view-distance=10
generate-structures=true
motd=$server_name
" > server.properties
