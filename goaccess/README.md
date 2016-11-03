Notes for [goacccess](https://goaccess.io), a web log analyzer

# examples

## s3 logs

#### single log file, use s3 config
```
cat LOG_FILE | goaccess -p ~/dotfiles/goaccess/s3
```

#### some files

Also see: [tons of files](#tons of files)

```
cat * | goaccess -p ~/dotfiles/goaccess/s3
```

##### errors

`cat *` may run into `Argument list too long`

The error from `cat` will be hidden by the `goaccess` screen takeover

#### lots of files

```
# `-exec ... +` will combine args (similar to xargs)
# greatly speeds things up by reducing the amount of spawned processes
find . -type f -exec cat {} + | goaccess -p ~/dotfiles/goaccess/s3
```

#### tons of files by filename
```
find -name "2016-11-03*" -exec cat {} + | goaccess -p ~/dotfiles/goaccess/s3
```
