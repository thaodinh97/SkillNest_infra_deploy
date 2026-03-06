package terraform.security

deny[msg] {
    rc := input.resource_changes[_]
    rc.type == "aws_s3_bucket"
    rc.change.after != null
    not has_s3_encrypt(rc)
    msg := sprintf("S3 bucket '%s' must enable server-side encryption", [rc.address])
}

has_s3_encrypt(rc) {
    rc.change.after.server_side_encryption_configuration != null
}

deny[msg] {
    rc := input.resource_changes[_]
    rc.type := "aws_security_group"
    ingress := rc.change.after.ingress[_]
    world_open(ingress.cidr_blocks)
    risky_port(ingress.from_port)

}

world_open(cidr_blocks)
{
    cidr_blocks[_] = "0.0.0.0/0"
}

risky_port(from_port) {
    from_port == 22
}

