
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

### Forward game to discord on linux
- Install [soundux](https://soundux.rocks/)
- Restart discord
- Run soundux
- Join discord call
- Refresh `output application` (right top)
- Select discord
- Click `pass through` (right bottom)
- Select game to pass through
- It should work
