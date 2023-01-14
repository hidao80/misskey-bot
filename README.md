# Misskey-bot

This is a submission shell script for Misskey that is easy to use with cron.

## Usage

```txt
usage: send_to_misskey.sh [-h] [-i <token>] [-t <text>] [-v <visibility>] <url>
    token:      Specify an API token. If not, refer to the environment variable MISSKEY_TOKEN.
    text:       Text to be sent
    visibility: Specify the scope of disclosure. If not, refer to the environment variable MISSKEY_VISIBLITY.
                Possible values are "public", "home", "followers", "specified". Default: "public"
```

### Example of using cron

```txt
# Runs only once a day, at a random time
 0  0 * * * sleep $(expr $RANDOM$RANDOM \% 86400); sh ~/bin/send_to_misskey.sh -t $(shuf -n 1 ~/bot/misskey/bot.words) -i $MISSKEY_TOKEN https://misskey.dev/api/notes/create > /dev/null

# time signal
 9  3 * * * sh ~/bin/send_to_misskey.sh -t "miku hatsune"       -i $MISSKEY_TOKEN https://misskey.dev/api/notes/create > /dev/null
00 13 * * * sh ~/bin/send_to_misskey.sh -t "afternoon thirteen" -i $MISSKEY_TOKEN https://misskey.dev/api/notes/create > /dev/null
55 23 * * * sh ~/bin/send_to_misskey.sh -t "older bro. Go Go!"  -i $MISSKEY_TOKEN https://misskey.dev/api/notes/create > /dev/null
```
