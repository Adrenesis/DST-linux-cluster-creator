create_directory() {
    path_to_directory="./$1/"
    if [ -d "$path_to_direcory" ]; then
        echo "$1 directory already exists"
    else
        mkdir -v $1
    fi
}

ask_port() {
    local var_check=false
    while [ $var_check = false ]
    do
        read -p "
Enter port for $1: " -n 5 -r port
        var_check=true
        [[ "$port" =~ ^[0-9]+$ ]] || var_check=false
        (( port >= 0 && port <= 65535 )) || var_check=false
    done
    echo $port
}


ask_ports() {
    echo "You will be asked for ports:"
    master_port=$(ask_port "master port (in cluster.ini)")
    master_server_port=$(ask_port "server port (in Master/server.ini)")
    master_master_server_port=$(ask_port "master server port (in Master/server.ini)")
    master_authentication_port=$(ask_port "authentication port (in Master/server.ini)")
    if [ $caves_disabled = false ]; then
        caves_server_port=$(ask_port "server port (in Caves/server.ini)")
        caves_master_server_port=$(ask_port "master server port (in Caves/server.ini)")
        caves_authentication_port=$(ask_port "authentication port (in Master/server.ini)")
    fi
}


prompt_cluster_creation() {
    read -p "Do you wish to create a new cluster?[y/N]" -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}
prompt_disable_caves() {
    read -p "Do you wish to enable caves?[Y/n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        caves_disabled=true
        shard=false
    else
        caves_disabled=false
        shard=true
    fi
}


prompt_gamemode() {
    var_check=false
    while [ $var_check = false ]
    do
        echo "Choose your gamemode:"
        echo
        echo "[1] Endless"
        echo "[2] Survival"
        echo "[3] Wilderness"
        read -p "" -n 1 -r
        case $REPLY in
            "1")
            gamemode="endless"
            var_check=true
            ;;
            "2")
            gamemode="survival"
            var_check=true
            ;;
            "3")
            gamemode="wilderness"
            var_check=true
            ;;
            *)
            echo "wrong value"
            echo
            var_check=false
        esac
    done
}

prompt_max_players() {
    local var_check=false
    while [ $var_check = false ]
    do
        read -p "
Enter the maximum number of players: " -n 2 -r
        var_check=true
        [[ "$REPLY" =~ ^[0-9]+$ ]] || var_check=false
        (( REPLY >= 1 && REPLY <= 64 )) || var_check=false
    done
    max_players=$REPLY
}    

prompt_pvp() {
    read -p "
Do you wish to enable pvp?[y/N]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pvp="true"
    else
        pvp="false"
    fi
}

prompt_pause_when_empty() {
    read -p "
Do you wish to pause the server when no one is connected?[Y/n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        pause_when_empty="false"
    else
        pause_when_empty="true"
    fi
}

prompt_cluster_name() {
    read -p "
Give your server a name:" -r
    cluster_name=$REPLY
}

prompt_console() {
    read -p "
Do you wish to enable console on your dedicated server?[Y/n]" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        console="false"
    else
        console="true"
    fi
}
prompt_intention() {
    var_check=false
    while [ $var_check = false ]
    do
        echo "Choose your gamemode:"
        echo
        echo "[1] Cooperative"
        echo "[2] Social"
        echo "[3] Competitive"
        echo "[4] Madness"
        read -p "" -n 1 -r
        case $REPLY in
            "1")
            intention="cooperative"
            var_check=true
            ;;
            "2")
            intention="social"
            var_check=true
            ;;
            "3")
            intention="competitive"
            var_check=true
            ;;
            "4")
            intention="madness"
            var_check=true
            ;;
            *)
            echo "wrong value"
            echo
            var_check=false
        esac
    done
}


prompt_password() {
    var_check=false

    while [ $var_check = false ]
    do
    read -s -p "Give your server a password:" -r
            password=$REPLY
    read -s -p "Type it again" -r
    if [ $REPLY = $password ]; then
        var_check=true
    fi
    done
}

    prompt_cluster_id() {
        read -p "
    Give your cluster an ID:" -r
        cluster_id=$REPLY
}    
    
prompt_intro() {
    echo "#########################################################"
    echo "###### DoNotStarveTogetherDedicated Server Manager ######"
    echo "#########################################################"
    echo -e "\n\n"
    echo "Welcome to DoNotStarveTogetherDedicated Server Manager"
    echo
    echo "Existing clusters:"
    ls -d ~/.klei/DoNotStarveTogether/*/ | awk -F'/' '{print $6}'
    echo
    echo "Clusters and shards running:"
    echo "---------------------------------------------------------"
    echo -e "|Cluster        |Shard    |    Running since    |"
    screen -ls | grep DST | awk -F'[.()_]' '{print "|-----------------------|-------|-----------------------|""\n|" $4 "            |" $6 "|" $7 "    |"}'
    echo "---------------------------------------------------------"
    echo 

    var_check=false
    while [ $var_check = false ]
    do
        echo "Choose what do you want to do:"
        echo 
        echo "[0] Create a new Cluster"
        echo "[1] Manage an existing Cluster"
        echo "[2] Exit"
        read -p "" -n 1 -r
        case $REPLY in
            "0")
            create_server
            ;;
            "1")
            prompt_manage_cluster
            ;;
            "2")
            var_check=true
            ;;
            *)
            echo "wrong value"
            echo
            var_check=false
        esac
    done

}
###
prompt_intro_create_server() {
    echo "#########################################################"
    echo "###### DoNotStarveTogetherDedicated Cluster Creator #####"
    echo "#########################################################"
    echo -e "\n\n"
    echo "You are about to create 3 ini files, to setup your new "
    echo "cluster, which are"
    echo "->./cluster.ini"
    echo "->./Master/server.ini"
    echo "->./Caves/serve.ini"
    echo -e "\n>"
    echo "Then, if you run this script in sudo you will be prompted"
    echo "to open you ports with iptables after the setup"
    echo -e "\n"
    echo "/!\\ You have to be in your cluster folder (default: "
    echo "/DoNotStarveTogether/Cluster_1/) before running this "    echo "script !!!"
    echo -e "\n"
    echo "You will have to enter 7 ports (only 4 if you dont use "
    echo "caves) which are:"
    echo "->master port (in cluster.ini)"
    echo "->server port (in Master/server.ini)"
    echo "->master server port (in Master/server.ini)"
    echo "->authentication port (in Master/server.ini)"
    echo "->server port (in Caves/server.ini) (Caves Only)"
    echo "->master server port (in Caves/server.ini) (Caves Only)"
    echo "->authentication port (in Caves/server.ini) (Caves Only)"
    echo -e "\n"
}

worldgen_lua() {
    echo -e "return {" >> "$1"
    echo -e "       override_enabled = true," >> "$1"
    echo -e "       preset = \"DST_CAVE\"," >> "$1"
    echo -e "}" >> "$1"

}

cluster_ini() {
    echo -e "[GAMEPLAY]" >> "${10}"
    echo -e "game_mode = $1" >> "${10}"
    echo -e "max_players = $2" >> "${10}"
    echo -e "pvp = $3" >> "${10}"
    echo -e "pause_when_empty = $4" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[NETWORK]" >> "${10}"
    echo -e "lan_only_cluster = false" >> "${10}"
    echo -e "offline_cluster = false" >> "${10}"
    echo -e "cluster_description =" >> "${10}"
    echo -e "cluster_name = $5" >> "${10}"
    echo -e "server_intention = $6" >> "${10}"
    echo -e "cluster_password = ${11}" >> "${10}"
    echo -e "cluster_intention = $6" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[MISC]" >> "${10}"
    echo -e "console_enabled = $7" >> "${10}"
    echo -e "\n" >> "${10}"
    echo -e "[SHARD]" >> "${10}"
    echo -e "shard_enabled = $8" >> "${10}"
    echo -e "bind_ip = 127.0.0.1" >> "${10}"
    echo -e "master_ip = 127.0.0.1" >> "${10}"
    echo -e "master_port = $9" >> "${10}"
    echo -e "cluster_key = defaultPass" >> "${10}"
}

serv_ini() {
    echo -e "[NETWORK]" >> "$5"
    echo -e "server_port =  $1" >> "$5"
    echo -e "\n" >> "$5"
    echo -e "[SHARD]" >> "$5"
    if [ $4 = true ]; then
        echo -e "is_master = true" >> "$5"
    else
        echo -e "is_master = false" >> "$5"
        echo -e "name = Caves" >> "$5"
    fi
    echo -e "\n" >> "$5"
    echo -e "[STEAM]" >> "$5"
    echo -e "master_server_port = $2" >> "$5"
    echo -e "authentication_port = $3" >> "$5"
}

set_serv_ini() {
    create_directory "$1"
    path_to_file="./$1/server.ini"
    if [ $1 = "Master" ]; then
            serv_ini "$master_server_port" "$master_master_server_port" "$master_authentication_port" true "$path_to_file"
    else
            serv_ini "$caves_server_port" "$caves_master_server_port" "$caves_authentication_port" false "$path_to_file"
    fi

}

prompt_manage_cluster() {
    pmc_cpt=0
    echo "Existing clusters:"
    ls -d ~/.klei/DoNotStarveTogether/*/ | awk -F'/' '{print $6}'
    echo
    echo "Clusters and shards running:"
    echo "---------------------------------------------------------"
    echo -e "|Cluster        |Shard    |    Running since    |"
    screen -ls | grep DST | awk -F'[.()_]' '{print "|-----------------------|-------|-----------------------|""\n|" $4 "            |" $6 "|" $7 "    |"}'
    echo "---------------------------------------------------------"
        echo 
    echo "Which cluster do you want to manage?"
    ls -d ~/.klei/DoNotStarveTogether/*/ | awk -F'/' '{print "["pmc_cpt++"] " $6;
                   array_cluster[pmc_cpt]=$6;}'
    array_cluster[7]=3
    echo ${array_cluster[1]}
}

create_server() {
    prompt_intro_create_server
    prompt_cluster_creation
    prompt_cluster_id
    prompt_disable_caves
    prompt_gamemode
    prompt_max_players
    prompt_pvp
    prompt_pause_when_empty
    prompt_console
    prompt_intention
    prompt_cluster_name
    prompt_password
    ask_ports
    cd ~/.klei/DoNotStarveTogether/ # << line you have to edit to be in the right folder
    create_directory "Cluster_$cluster_id"
    cd Cluster_$cluster_id/
    set_serv_ini "Master"
    if [ $caves_disabled = false ]; then
    set_serv_ini "Caves"
    path_to_file="./Caves/worldgenoverride.lua"
    worldgen_lua "$path_to_file"
    fi

    path_to_file="./cluster.ini"
    cluster_ini "$gamemode" "$max_players" "$pvp" "$pause_when_empty" "$cluster_name" "$intention" "$console" "$shard" "$master_port" "$path_to_file" "$password"
    password=" "
    cd ~
    cp -f ~/.klei/DoNotStarveTogether/cluster_token.txt ~/.klei/DoNotStarveTogether/Cluster_$cluster_id/
    prompt_intro
}
####MAIN####
prompt_intro

