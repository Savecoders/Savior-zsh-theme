# install oh-my-zsh and change theme

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "move theme to custom theme folder"
cp ./Savior.zsh-theme ~/.oh-my-zsh/themes/

echo "change default theme to Savior"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="Savior"/g' ~/.zshrc
