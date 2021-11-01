

[Proxy.py](https://pypi.org/project/proxy.py/)

```sh
proxy --hostname 0.0.0.0
```

```py
import httpx

proxies = {
    "http://": "http://x.x.x.x:port",
    "https://": "http://x.x.x.x:port",
}

with httpx.Client(proxies=proxies) as client:
    s = client.get("https://icanhazip.com")
    print(s.content)
```
