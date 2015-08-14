

# 隠しファイルの表示切り替え
function toggle-show-all-files() {
    IS_SHOW_ALL_FILES=`defaults read com.apple.finder AppleShowAllFiles`
    if $IS_SHOW_ALL_FILES ; then
        defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder
    else
        defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder
    fi
}
