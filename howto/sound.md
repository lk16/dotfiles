
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


### Setup guitarix on linux
- Setup `qjackctl`, see [here](https://askubuntu.com/a/935564)
- Check if user is in `audio` group by running `groups`
- If not add with `sudo adduser $USER audio`
- Run `newgrp audio` to reload groups and confirm with `groups`
- Run `qjackctl`
- Set sample rate to `88200`
- In `qjackctl` open the `Connect` window and connect these:
    - `system` `capture_1` to `gx_head_amp` `in_0`
    - `gx_head_amp` `out_0` to `gx_head_fx` `in_0`
    - `gx_head_fx` `out_0` to `system` `playback_1`
