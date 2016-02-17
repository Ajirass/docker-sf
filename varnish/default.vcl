# Marker to tell the VCL compiler that this VCL has been adapted to the
# new 4.0 format.
vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "nginx";
    .port = "80";
}

sub vcl_recv {
    # Happens before we check if we have this in cache already.
    #
    # Typically you clean up the request here, removing cookies you don't need,
    # rewriting the request, etc.

    if (req.http.X-Forwarded-Proto == "https" ) {
        set req.http.X-Forwarded-Port = "443";
    } else {
        set req.http.X-Forwarded-Port = "80";
    }

    if (req.http.Cookie) {
        set req.http.Cookie = ";" + req.http.Cookie;
        set req.http.Cookie = regsuball(req.http.Cookie, "; +", ";");
        set req.http.Cookie = regsuball(req.http.Cookie, ";(PHPSESSID)=", "; \1=");
        set req.http.Cookie = regsuball(req.http.Cookie, ";[^ ][^;]*", "");
        set req.http.Cookie = regsuball(req.http.Cookie, "^[; ]+|[; ]+$", "");

        if (req.http.Cookie == "") {
            // If there are no more cookies, remove the header to get page cached.
            unset req.http.Cookie;
        }
    }
    // Add a Surrogate-Capability header to announce ESI support.
    set req.http.Surrogate-Capability = "abc=ESI/1.0";
    return (hash);
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.

    // Check for ESI acknowledgement and remove Surrogate-Control header
    if (beresp.http.Surrogate-Control ~ "ESI/1.0") {
        unset beresp.http.Surrogate-Control;
        set beresp.do_esi = true;
    }
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}


#sub vcl_recv {
#  if (req.request == "PURGE") {
#    return(lookup);
#  }
#  if (req.url ~ "^/$") {
#    unset req.http.cookie;
#  }
#}
#
#sub vcl_hit {
#  if (req.request == "PURGE") {
#    set obj.ttl = 0s;
#    error 200 "Purged.";
#  }
#}
#
#sub vcl_miss {
#  #if purge request was not found, send 404 error
#  if (req.request == "PURGE") {
#    error 404 "Not in cache.";
#  }
#  #if request was not meant for the Wordpress admin interface, unset cookies
#  if (!(req.url ~ "wp-(login|admin)")) {
#    unset req.http.cookie;
#  }
#  #remove cookies from static resources
#  if (req.url ~ "^/[^?]+.(jpeg|jpg|png|gif|ico|js|css|txt|gz|zip|lzma|bz2|tgz|tbz|html|htm)(\?.|)$") {
#    unset req.http.cookie;
#    set req.url = regsub(req.url, "\?.$", "");
#  }
#  if (req.url ~ "^/$") {
#    unset req.http.cookie;
#  }
#}
#
#sub vcl_fetch {
#  set beresp.ttl = 1w;
#
#  if (req.url ~ "^/$") {
#    unset beresp.http.set-cookie;
#  }
#
#  #bypass the proxy if the url contains the admin, login, preview or the xmlrpc
#  if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php") {
#    return (hit_for_pass);
#  }
#
#  if (!(req.url ~ "wp-(login|admin)")) {
#    unset beresp.http.set-cookie;
#  }
#}