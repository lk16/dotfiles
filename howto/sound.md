
### Adjust sound volume

* Using `pactl`:
```sh
# list available sinks
pactl list sinks

# Adjust sound level (1 is the sink id)
pactl set-sink-volume 1 +3%
pactl set-sink-volume 1 -3%

# Set sound level (1 is the sink id)
pactl set-sink-volume 1 5%
```

* Using `amixer`:
```sh
# volume up
amixer -D pulse sset Master 5%+

# volume down
amixer -D pulse sset Master 5%-
```
