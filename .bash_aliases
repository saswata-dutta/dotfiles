#dot files git config
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias cp='cp -irv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'

to () {
  cd "$1"
  pwd
  echo
  ls -ACF
  echo
}

alias ...='../..'
alias ....='../../..'
alias -- -='cd -'

alias c=clear

# epoch stuff
from-unixtime () {
    in="$1"
    gdate --date="@${in:0:10}"
}

alias unixtime='date +%s'

date-range () {
  current="$1"
  stop="$2"
  until [[ $current > $stop ]]; do
    echo "$current"
    current=$(gdate -I -d "$current + 1 day")
  done
}

export HISTTIMEFORMAT="%F %T "

alias ip='curl "ipinfo.io"; echo'
# some more ls aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias lh='ll -1t | head'

####### rivigo #########
## sshttle
# stl-all () {
#   sshuttle --dns -D --pidfile=/tmp/sshuttle.pid -x 13.126.0.23 -r sd5711@bastion.vyom.com 0/0 && curl "ipinfo.io"
# }

# stl () {
#   sshuttle --dns -D --pidfile=/tmp/sshuttle.pid -x 13.126.0.23 -r sd5711@bastion.vyom.com 10.0.0.0/0 && curl "ipinfo.io"
# }

# stl-off () {
#   # [[ -f $SSHUTTLE_PID_FILE ]] && 
#   kill $(cat /tmp/sshuttle.pid) && curl "ipinfo.io"
# }

#alias stl="sshuttle --dns -r sd5711@13.126.0.23 0.0.0.0/0"
#alias stl="sshuttle --dns -x 13.126.0.23 -r sd5711@13.126.0.23 0.0.0.0/0"
#"sshuttle --dns --verbose --exclude 13.126.0.23 --remote sd5711@13.126.0.23 0.0.0.0/0"


#### db configs
# prod_dump () {
# 	mycli -d prod_dump	
# }


### ssh

ssh-ip () {
	ssh -G "$1" | head -2
}

# tnl () 
# {
#   DB=vyom-"$1".cqgxnxnhglky.ap-south-1.rds.amazonaws.com
#   ssh -C -f sd5711@13.126.0.23 -L 3306:"$DB":3306 sleep 300
# }

## ssh

# jmp ()
# {
#   ssh -J bastion sd5711@"$1"
# }

# copy-vim-config() {
#   scp -rp ~/.vim  "$1":
#   scp ~/.vimrc  "$1":
#   ssh "$1" 'cd ~/.vim/pack/tpope/start'
#   ssh "$1" 'vim -u NONE -c "helptags sensible/doc" -c q'
# }

## logs

# mnt-logs ()
# {

#   #unmnt-logs $2
#   #ssh -C -f bastion -L "$2":"$1":22 -N
#   #sshfs -o ro -d -o allow_other -o reconnect -o ServerAliveInterval=15 -C -o workaround=all -p "$2" sd5711@localhost:/var/log/tomcat8/log/ ~/mnt/remote-logs/

#   unmnt-logs
#   sshfs -d -C -o noappledouble,negative_vncache,auto_cache,ro,allow_other,reconnect,defer_permissions,ServerAliveInterval=15,IdentityFile=~/.ssh/id_rsa sd5711@"$1":/var/log/tomcat8/log/ ~/mnt/remote-logs/
# }

# unmnt-logs ()

# {

#   #fusermount -u ~/mnt/remote-logs
#   #ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:$1"
#   #killall ssh
#   #ps aux | grep "ssh"

#   umount ~/mnt/remote-logs/
# }


### aws cli

alias kms-get="aws ssm get-parameters --region ap-south-1 --with-decryption --names "

ec2-name () {

  ips="$*"

  aws ec2 describe-instances \
  --filters "Name=private-ip-address,Values=$ips" \
  --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value' \
  --no-paginate --output=text
}

ec2-ip () {

  aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$1" "Name=instance-state-code,Values=16" \
  --query 'Reservations[*].Instances[*].[PrivateIpAddress]' \
  --output text --no-paginate
}

ec2-fuzzy-ip () {

  fuzzy_name="*$1*"

  aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$fuzzy_name" "Name=instance-state-code,Values=16" \
  --query 'Reservations[].Instances[].{ name : Tags[?Key==`Name`].Value | [0], ip : PrivateIpAddress }' \
  --no-paginate \
  | jq 'group_by(.name) | map({ (.[0].name) : ([.[].ip]) })'
}

ebs-ver () {
  aws elasticbeanstalk describe-environments \
  --application-name "$1" \
  --query 'Environments[*].[EnvironmentName,VersionLabel]' \
  --output text --no-paginate
}


### clear mac net prefs
del-mac-net-prefs () {
  cd /Library/Preferences/SystemConfiguration/
  BK_DIR=/Users/saswatdutta/net-files/
  mv com.apple.airport.preferences.plist $BK_DIR
  mv preferences.plist $BK_DIR
  mv NetworkInterfaces.plist $BK_DIR
  cd -
}

##### gradle bootrun
alias gcb="gw clean build"

# gbr () {

# echo > /var/log/tomcat8/log/vyom_payments.log
# echo > /var/log/tomcat8/log/application.log
# echo > /var/log/tomcat8/log/profile/profile.log
# echo > /var/log/tomcat8/log/reqresp/api.log
# echo > /var/log/tomcat8/log/reqresp/extapi.log
# rm -f /var/log/tomcat8/log/reqresp/*.gz
# rm -f /var/log/tomcat8/log/profile/*.gz
# rm -f /var/log/tomcat8/log/*.gz

# gradle clean bootrun -Dspring.profiles.active=dev -Djavax.net.ssl.keyStore=/Users/saswatdutta/keys/client-keystore.jks -Djavax.net.ssl.keyStorePassword=changeit

# }

#### port fwd

# dbfwd () {


#   ssh -f sd5711@13.126.0.23 -L3306:vyom-dev.cqgxnxnhglky.ap-south-1.rds.amazonaws.com:3306 -N

#   ssh -f sd5711@13.126.0.23 -L6379:vyom-demand-dev.t3yfqz.0001.aps1.cache.amazonaws.com:6379 -N

#   ssh -f sd5711@13.126.0.23 -L27017:10.0.1.159:27017 -N

# }

# dbfwd_stg () {

#   ssh -f sd5711@13.126.0.23 -L3306:vyom-stg.cqgxnxnhglky.ap-south-1.rds.amazonaws.com:3306 -N

#   ssh -f sd5711@13.126.0.23 -L6379:vyom-demand-stg.t3yfqz.0001.aps1.cache.amazonaws.com:6379 -N

#   ssh -f sd5711@13.126.0.23 -L27017:10.0.1.159:27017 -N

# }

######## run app

# make_logs () {
# true > /var/log/tomcat8/log/profile/api.log
# true > /var/log/tomcat8/log/vyom_payments.log
# true > /var/log/tomcat8/log/reqresp/extapi.log
# }

# app_run () {

# 	killall ssh
# 	killall sshuttle
# 	make_logs
# 	stl
# 	gbr
# }


######### git alias #######
alias git="/usr/local/bin/git"
alias g="/usr/local/bin/git"

gl () {
    if [[ $# -eq 0 ]] ; then
        git l -10
    else
        git l -"$1"
    fi
}

alias gb="git branch"

alias gco="git checkout"

alias gp="git fetch --all --prune --prune-tags && git rebase"

alias gcls="git reset --hard HEAD"

alias gs="git status"

alias gc="git commit"
alias gcam="git commit -am "

alias ga="git add -u"
alias gal="git add -A"

alias gd="git diff -w"
alias gdc="git diff -w --cached"

alias gnb="git checkout --no-track -b"
alias gnrb="git push -f -u"

#alias gtb="git fetch --all && git checkout --track "

alias gfix="git commit --amend --no-edit"

alias gstage="git add -- "

alias gunstage="git reset HEAD -- "

alias gfnm="git show --name-only"


gfr() {
 git reset @~ "$@" && git commit --amend --no-edit
}


# brew
alias brewup='brew update; brew upgrade; brew cleanup --prune-prefix; brew cleanup; brew doctor'

# enable fsad autojump
eval "$(fasd --init auto)"


#### cd-able vars -- vyom specific
c="$HOME/code"
m="$HOME/code/mine"

# mac dns flush
flush-dns () {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# text highlights 

highlight() {
  declare -A fg_color_map
  fg_color_map[black]=30
  fg_color_map[red]=31
  fg_color_map[green]=32
  fg_color_map[yellow]=33
  fg_color_map[blue]=34
  fg_color_map[magenta]=35
  fg_color_map[cyan]=36
   
  fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
  c_rs=$'\e[0m'
  sed -u s"/$2/$fg_c\0$c_rs/g"
}

grepe () {
	grep --color -E "$1|$" $2
}

# httpie
alias https='http --default-scheme=https'

# python3 venv
alias py_env_new="python3 -m venv env"
alias py_env_del="rm -rf env"
alias py_env_on="source ./env/bin/activate && which python3"
alias py_env_off="deactivate"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

alias df="gdf -Tha --total"
alias du="gdu -ach | sort -h"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# data
i() {
  (head -n 5; tail -n 5) < "$1" | column -t
}

## spark
export SPARK_HOME=$(brew info apache-spark | grep '/usr' | tail -n 1 | cut -f 1 -d " ")/libexec
export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH

export HADOOP_HOME=$(brew info hadoop | grep '/usr' | head -n 1 | cut -f 1 -d " ")/libexec
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native/:$LD_LIBRARY_PATH

# youtube
yt() {
  youtube-dl "https://www.youtube.com/watch?v=$1"
}
