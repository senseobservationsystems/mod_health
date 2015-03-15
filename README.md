#mod_health

Monitor Ejabberd and any applications running on it.
Based on https://www.ejabberd.im/mod_monitor_web but updated for Ejabberd 14.02+


## Ejabberd Config
First make sure the module is added in ejabberd.yml on the server port

```yml
  - 
    port: 5280
    module: ejabberd_http
    request_handlers:
      "/health": mod_health
    web_admin: true
    http_poll: true
    http_bind: true
    ## register: true
    captcha: true
```

This will create an endpoint for mod_health to listen to at localhost:5280/health

## Adding additional applications to check

Define the application name as a constant at the top of the file:

```erlang
-define(MYSQL, mysql).
```

And then add the check in the check_health function:

```erlang
MySQL = get_status(?MYSQL),
```


## Output


You will get a JSON response with a true/false value to tell you if that service is currently running

```json
{
	"ejabberd": true,
	"mnesia": true,
	"cyrpto": true,
	"ssl": false,
}
```

## Dependancies 

It required JSX (https://github.com/talentdeficit/jsx) for encoding the responses




