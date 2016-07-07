#! /bin/bash

screen_name="mineserver-server"
http_screen_name="mineserver-http"

case $1 in
    start)
        echo "Starting $server_name ..."

        if [ -z $2 ]
        then
          echo "specify server name"
          exit
        fi

        server_path="$PWD/../server/$2"
        server_config_path="$PWD/servers/$2"

        if [ ! -d "$server_path" ]
        then
            echo "install server first!"
            exit
        fi
        . "$server_config_path"

        server_name="$2"
        jar_file="forge-$forge_version-universal.jar"
        pid_file="$PWD/tmp/server_pid"



        if screen -list | grep -q "$screen_name"; then
          echo "another server is already running ..."
        else
          echo "Starting Minecraft"
          cd "$server_path"
          screen -S "$screen_name" -d -m java -jar $jar_file
          echo "Minecraft started ..."
          echo "Starting http server"
          cd "$server_path/mods"
          screen -S "$http_screen_name" -d -m http-server -p 80
          echo "Http server started"

        fi
    ;;
    stop)
        if screen -list | grep -q "$screen_name"; then
            echo "server stoping ..."
            screen -S "$screen_name" -p 0 -X stuff "stop$(printf \\r)"
            screen -S "$http_screen_name" -p 0 -X stuff $'\003'
            echo "server stopped ..."
        else
            echo "server is not running ..."
        fi
    ;;
    join)
      screen -r "$screen_name"
    ;;
esac
