# .tmux-system

You can simply clone this repository and in your .tmux.conf do:

    set-option -g status-right "#(.tmux-system/get_load_averages.sh) #(.tmux-system/get_memory_usage.sh)"

In case you use this code and come across bugs please do let me know!
