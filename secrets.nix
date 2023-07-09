let
  mbp-14 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ47Qtg6qSenUh6Whg3ZIpIhdZZdqdG+L1z2f9UnB+Mw";
  mbp-16 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVktHp6yjTknysVbU24K014tFKCIIM3/rWqZV591NRn";

  user-keys = [
    mbp-14
    mbp-16
  ];

  server-ams = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCd98YeQmY5HOvC7q/0O+f6t1pSw5Tin1JdaFCVd9DckOZBLK4uIJJyvTZCKN1vdPMPh6CmTeOyjmCURQkHfkhLD3u9JFX2GHJ7Wa2O6/JQ6ikXCRWYirMMdKySbDANcRERedt0Z7/sgdJpkFHybtapgyvEJVcqsEqjfycgVDOQ4377t2I//Zk+QLmDEjpmubIILF/yLWH8hmr3muG9Brp3WbRnqI1+WocigmZXK21vTTCG3RgAR3CoAspxIad3S5yTJE++rqewyAz4CdnG8J1GCBjR49QuQo+4Q8R7u+8fzlFVhESEzesVatdz+gx0O99ZO/P4lNe3Nc3Oep19dUDf7IMiNIQhNraXxzU7aEZKj7SaJa6H5rw3WIYk62NKIcSHrLyreDhqKhczkGN9WnWmcU6fWbANVC+OfaF1E6aXEkSBnpK29FeVlE/IF4QndbFI/pG1sGqgFzo7kSy9N/UnvfFdKbupxjLu3BXK8Jn2NAD2dZTVaU1WvWdtlz8o0QM=";
  server-jfk = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD1WafsXveyMKUgxHR1ETJP2tx/5XdPxMKoooL9bwzo145nrkE0o6emF5lA6e5yqY4YjkExEv4jdOBkKwC5ycUphRJh8NZUnRixBF7eJvHi5M9KbhUqfmS/C7Htk9ASPetTd9GkbR1vwHyNFF0x9TKbZXItWsZG+raBqlABhSN4epUR6wqvJnYeRoXO0TXb8hg1BBNRIIJQ2ikk4UmSkjnu0HT2/W6oLkc2MDsvOYn9aj8kR9/JV0jPWz44zh8p7B8jBGJEQEkKZOrmRnXHEkzCKknXTjDB4tegrjqJ7fJNVR5kfZqMk5NRLBIqrf2XtzxBl4KIXovueL7KinNo0B2uOkj1jly+Fe5mWLBRcnrZYv+A0vvQbONIGYfMQ+UaJWxvSFlY/y6aOwALMgC5dYlBSlo4w4sBNwSvC6Th7cmnBYA5EhWOSyEW2M42X9yGLjVQgWPulRuS03LApEOY25pBxss8jSz4LMkZXfiaURv0Iq+DSB6Unj5T8rHosRFPBBk=";
  server-nrt = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKSS6NjDOzTmsv/sbv3Fs9nVRFA2lDMT61T6YzJrHhKtmhjpAhUd+dPXhcr7oiE2pw+6bK96pHZrdzOPRK6qUluowSdVwknimpLZHLiP2mDFldsY1eBkTXdK9kZLGbHt+dfqwdPgV1W//8dJ2loGWDT6zJkwtDMTnsRoLRtNZCPR4zW8uhAtQnIM3rxgBiz1Lb9tkQqsSUpYN6693JsT8r2ieJOwOd05i2Jh+Jpgme/RIUn6dN1eo1Ye3eM52/HF4N4wPoDpzSOjkh0XFlcUtYkXm9dzg8/bQX68oP9JcmFGLR7cIE/l8nThILke3/8zjKjG6EBUBdhDAKhBefbjzoTjCutTdwN2kJwEOMHJnMR/p/rmVvjFMzhdIakipBQo31WKEpzgll7oWpBbajMKTrz/RDHY1kqrGRc7igxB5CgQVlMMg/+jbDlQPwWTrIxRIKoECml3DRrEYLeb7XWi1gzJxOANZkCcZEJCeUrGYUqjAnuU+wsPB3cLdmXgH+288=";

  server-keys = [
    server-ams
    server-jfk
    server-nrt
  ];
in
{
  "secrets/gpg.age".publicKeys = user-keys;

  "secrets/mbp-14.age".publicKeys = user-keys;
  "secrets/mbp-16.age".publicKeys = user-keys;

  "secrets/server-ams.age".publicKeys = user-keys ++ server-keys;
  "secrets/server-jfk.age".publicKeys = user-keys ++ server-keys;
  "secrets/server-nrt.age".publicKeys = user-keys ++ server-keys;
}
