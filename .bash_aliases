#dot files git config
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias ...='../..'
alias ....='../../..'
alias -- -='cd -'

alias c=clear

# some more ls aliases

alias ll='ls -alF'

alias la='ls -A'

alias l='ls -CF'

## sshttle
stl-aws () {
  sshuttle --dns -D --pidfile=/tmp/sshuttle.pid -x 13.126.0.23 -r sd5711@13.126.0.23 0.0.0.0/8 && echo 'Connected'
}

stl () {
  sshuttle --dns -D --pidfile=/tmp/sshuttle.pid -x 13.126.0.23 -r sd5711@13.126.0.23 10.0.0.0/0 && echo 'Connected'
}

stl-off () {
  [[ -f $SSHUTTLE_PID_FILE ]] && kill $(cat /tmp/sshuttle.pid) && echo 'Disconnected' 
}

#alias stl="sshuttle --dns -r sd5711@13.126.0.23 0.0.0.0/0"
#alias stl="sshuttle --dns -x 13.126.0.23 -r sd5711@13.126.0.23 0.0.0.0/0"
#"sshuttle --dns --verbose --exclude 13.126.0.23 --remote sd5711@13.126.0.23 0.0.0.0/0"


#### db configs
prod_dump () {
	mycli -d prod_dump	
}


### ssh

ssh-ip () {
	ssh -G "$1" | head -2
}

tnl () 
{
  DB=vyom-"$1".cqgxnxnhglky.ap-south-1.rds.amazonaws.com
  ssh -C -f sd5711@13.126.0.23 -L 3306:"$DB":3306 sleep 300
}

## ssh

jmp ()
{
  ssh -J bastion sd5711@"$1"
}

copy-vim-config() {
  scp -rp ~/.vim  "$1":
  scp ~/.vimrc  "$1":
  ssh "$1" 'cd ~/.vim/pack/tpope/start'
  ssh "$1" 'vim -u NONE -c "helptags sensible/doc" -c q'
}

## logs

mnt-logs ()
{

  #unmnt-logs $2
  #ssh -C -f bastion -L "$2":"$1":22 -N
  #sshfs -o ro -d -o allow_other -o reconnect -o ServerAliveInterval=15 -C -o workaround=all -p "$2" sd5711@localhost:/var/log/tomcat8/log/ ~/mnt/remote-logs/

  unmnt-logs
  sshfs -d -C -o noappledouble,negative_vncache,auto_cache,ro,allow_other,reconnect,defer_permissions,ServerAliveInterval=15,IdentityFile=~/.ssh/id_rsa sd5711@"$1":/var/log/tomcat8/log/ ~/mnt/remote-logs/
}

unmnt-logs ()

{

  #fusermount -u ~/mnt/remote-logs
  #ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:$1"
  #killall ssh
  #ps aux | grep "ssh"

  umount ~/mnt/remote-logs/
}


### aws cli

alias kms-get="aws ssm get-parameters --region ap-south-1 --with-decryption --names "

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
  --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value,PrivateIpAddress]' \
  --no-paginate \
  | jq '[ .[] | { name: .[0][0][0], ip: .[0][1] } ]' \
  | jq 'group_by(.name) | map({ (.[0].name) : ([.[].ip]) })'
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
alias gcb="gradle clean build"

gbr () {

echo > /var/log/tomcat8/log/vyom_payments.log
echo > /var/log/tomcat8/log/application.log
echo > /var/log/tomcat8/log/profile/profile.log
echo > /var/log/tomcat8/log/reqresp/api.log
echo > /var/log/tomcat8/log/reqresp/extapi.log
rm -f /var/log/tomcat8/log/reqresp/*.gz
rm -f /var/log/tomcat8/log/profile/*.gz
rm -f /var/log/tomcat8/log/*.gz

gradle clean bootrun -Dspring.profiles.active=dev -Djavax.net.ssl.keyStore=/Users/saswatdutta/keys/client-keystore.jks -Djavax.net.ssl.keyStorePassword=changeit

}

#### port fwd

dbfwd () {


  ssh -f sd5711@13.126.0.23 -L3306:vyom-dev.cqgxnxnhglky.ap-south-1.rds.amazonaws.com:3306 -N

  ssh -f sd5711@13.126.0.23 -L6379:vyom-demand-dev.t3yfqz.0001.aps1.cache.amazonaws.com:6379 -N

  ssh -f sd5711@13.126.0.23 -L27017:10.0.1.159:27017 -N

}

dbfwd_stg () {

  ssh -f sd5711@13.126.0.23 -L3306:vyom-stg.cqgxnxnhglky.ap-south-1.rds.amazonaws.com:3306 -N

  ssh -f sd5711@13.126.0.23 -L6379:vyom-demand-stg.t3yfqz.0001.aps1.cache.amazonaws.com:6379 -N

  ssh -f sd5711@13.126.0.23 -L27017:10.0.1.159:27017 -N

}

######## run app

make_logs () {
true > /var/log/tomcat8/log/profile/api.log
true > /var/log/tomcat8/log/vyom_payments.log
true > /var/log/tomcat8/log/reqresp/extapi.log
}

app_run () {

	killall ssh
	killall sshuttle
	make_logs
	stl
	gbr
}

######### git alias #######
alias git="/usr/local/bin/git"
alias g="/usr/local/bin/git"

alias gl="git l"
alias gl5="git l -5"
alias gl10="git l -10"

alias gb="git branch"

alias gco="git checkout"

alias gp="git fetch --all && git rebase"

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
alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

eval "$(fasd --init auto)"


#### cd-able vars -- vyom specific
c="$HOME/code"
m="$HOME/code/mine"
v="$HOME/code/vyom"
p="$HOME/code/vyom/payments"
s="$HOME/code/vyom/supply"
fe="$HOME/code/vyom/fuel"

# mac dns flush
flush-dns () {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}


