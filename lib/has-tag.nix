{ lib }:

hostName: tag:
lib.elem tag (lib.blueprint.hosts.${hostName}.tags or [ ])
