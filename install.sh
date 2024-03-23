# install oh-my-zsh

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "move theme to custom theme folder"
cp ./Savior.zsh-theme ~/.oh-my-zsh/custom/themes/

echo "change theme to Savior"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="Savior"/g' ~/.zshrc