{ lib, ... }:

let
  inherit (lib.terranix) tfRef;
  inherit (lib.blueprint) services;

  workspace = tfRef "fastly_ngwaf_workspace.ngwaf.id";

  is = field: value: { inherit field value; operator = "equals"; };

  like = field: value: { inherit field value; operator = "like"; };

  any = condition: { group_operator = "any"; inherit condition; };

  # allow action will win over every block action but keeps inspection and tagging
  allow = { description, signal, condition ? [ ], group_condition ? [ ], multival_condition ? [ ] }: {
    workspace_id = workspace;
    type = "request";
    inherit description condition group_condition multival_condition;
    enabled = true;
    request_logging = "sampled";
    group_operator = "all";
    action = [
      { type = "allow"; }
      { type = "add_signal"; signal = tfRef "fastly_ngwaf_workspace_signal.${signal}.reference_id"; }
    ];
  };

  # a request header or cookie with this name is present
  has = field: name: { inherit field; operator = "exists"; group_operator = "all"; condition = [ (is "name" name) ]; };
  header = has "request_header";
  cookie = has "request_cookie";
  contentType = value: {
    field = "request_header";
    operator = "exists";
    group_operator = "all";
    condition = [ (is "name" "Content-Type") { field = "value_string"; operator = "contains"; inherit value; } ];
  };

  # see tailscale snippet in modules/nixos/caddy/default.nix
  tailnet = [ "100.64.0.0/10" "fd7a:115c:a1e0::/48" ];
in
{
  resource.fastly_ngwaf_workspace.ngwaf = {
    name = "NGWAF";
    description = "Next-Gen WAF";
    mode = "block";

    # this block is required
    attack_signal_thresholds = [{
      immediate = true;
      one_minute = 50;
      ten_minutes = 350;
      one_hour = 1800;
    }];
  };

  # the api cannot rename a signal, so a new name replaces it and the rules must move to the new one first
  resource.fastly_ngwaf_workspace_signal = lib.mapAttrs
    (_: signal: signal // {
      workspace_id = workspace;
      lifecycle.create_before_destroy = true;
    })
    {
      niks3 = { name = "Niks3 Push"; description = "Authenticated calls to the niks3 API from a binary cache push."; };
      plausible = { name = "Plausible Beacon"; description = "Analytics events posted by the plausible tracker script."; };
      reports = { name = "CSP Report"; description = "CSP and NEL reports posted by browsers to the collector."; };
      tailnet = { name = "Tailnet Client"; description = "Requests from tailnet addresses to the sites that only answer the tailnet."; };
      kanidm = { name = "Kanidm Credential"; description = "Passwords and codes posted to the Kanidm login forms and auth API."; };
      grafana = { name = "Grafana Session"; description = "Grafana API calls from a signed in browser session."; };
      neogrok = { name = "Neogrok Search"; description = "Code searches from a session that passed the Caddy OIDC gate."; };
    };

  resource.fastly_ngwaf_workspace_rule = {
    # all mutating niks3 route needs a bearer token
    # uploads go to storage backend through presigned urls
    niks3 = allow {
      description = "Allow authenticated niks3 API calls on ${services.niks3.domain}.";
      signal = "niks3";
      condition = [ (is "domain" services.niks3.domain) (like "path" "/api/*") ];
      multival_condition = [ (header "Authorization") ];
    };

    # tracker posts text/plain (sigsci agent dont parse this thus only url and header signals remain)
    plausible = allow {
      description = "Allow the plausible beacon on ${services.plausible.domain}.";
      signal = "plausible";
      condition = [ (is "domain" services.plausible.domain) (is "method" "POST") (is "path" "/api/event") ];
      multival_condition = [ (contentType "text/plain") ];
    };

    # see modules/nixos/caddy/default.nix and modules/nixos/go-csp-collector.nix
    reports = allow {
      description = "Allow browser CSP and NEL reports on ${services.go-csp-collector.domain}.";
      signal = "reports";
      condition = [ (is "domain" services.go-csp-collector.domain) (is "method" "POST") ];
      group_condition = [ (any [ (is "path" "/csp") (is "path" "/reporting-api/csp") (is "path" "/nel") ]) ];
      multival_condition = [ (contentType "report") ];
    };

    # caddy will 404 to everything else go check caddy `(tailscale)` snippet
    tailnet = allow {
      description = "Allow tailnet clients on the sites that only answer the tailnet.";
      signal = "tailnet";
      group_condition = [
        (any (map (is "domain") [ services.home-assistant.domain services.paperless.domain services.vaultwarden.domain ]))
        (any (map (is "ip") tailnet))
      ];
    };

    # password and 2fa code posted to login forms and auth api
    kanidm = allow {
      description = "Allow credential posts to the Kanidm login forms and auth API on ${services.kanidm.domain}.";
      signal = "kanidm";
      condition = [ (is "domain" services.kanidm.domain) (is "method" "POST") ];
      group_condition = [ (any [ (like "path" "/ui/login/*") (like "path" "/v1/auth*") (is "path" "/v1/reauth") ]) ];
    };

    # queries from signed in sessions (anonymous public dashboard traffic are enforced)
    grafana = allow {
      description = "Allow API calls from a signed in Grafana session on ${services.grafana.domain}.";
      signal = "grafana";
      condition = [ (is "domain" services.grafana.domain) (like "path" "/api/*") ];
      multival_condition = [ (cookie "grafana_session") ];
    };

    # code search look like attacks but caddy validates the oidc session before proxying
    neogrok = allow {
      description = "Allow code searches from a session that passed the Caddy OIDC gate on ${services.neogrok.domain}.";
      signal = "neogrok";
      condition = [ (is "domain" services.neogrok.domain) ];
      multival_condition = [ (cookie "session") ];
    };
  };
}
