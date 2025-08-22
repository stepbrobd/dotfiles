```nu
(curl -s https://api.cloudflare.com/client/v4/zones/($env.ZONE_ID)/settings
  -X PATCH
  -H "Content-Type: application/json"
  -H $"X-Auth-Email: ($env.CLOUDFLARE_EMAIL)"
  -H $"X-Auth-Key: ($env.CLOUDFLARE_API_KEY)"
  -d (cat <free or enterprise settings in json>))
```

```nu
terranix packages/stepbrobd/cloudflare/default.nix | save -f config.tf.json
```
