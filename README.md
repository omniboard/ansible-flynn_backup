# Flynn CLI

This Ansible role creates cron jobs that download a backup from each [Flynn](https://flynn.io) cluster and upload them to an S3 bucket.

Flynn CLI client must be configured, and access to each Flynn cluster must to be configured, which can be done with the flynn_cli Ansible role.

## Role Variables

```yml
# User account from which the backup jobs will be run. It must already exist.
flynn_backup_username: flynnbackups

# List of the the Flynn clusters to be backed up, along with cron time settings for the backup.
# The cluster names will need to have been configured for the user using the flynn_cli role.
# For more information on the cron settings, see the Ansible cron module.
flynn_backup_clusters:
- name: cluster0
  month: *
  day: *
  weekday: *
  hour: *
  minute: 0

# flynn_backup_remove_clusters:
- old_cluster

# Credentials to connect to AWS.
flynn_backup_aws:
  access_key_id: key
  secret_access_key: secret

# S3 bucket in which to place backups
flynn_backup_s3_bucket_region: us-east-1
flynn_backup_s3_bucket_name: bucketname

# If the cron job script fails, details will be sent to your Sentry account.
# Get the DSN from sentry.io.
flynn_backup_sentry_dsn: https://example.sentry.io/123

# Directory where cron job output will be placed. Will be created.
flynn_backup_log_directory: /var/log/flynnbackups

# Location of the backup script executable that will be created and used by cron jobs.
flynn_backup_executable: /usr/local/bin/flynnbackup
```

## Example

```yml
- hosts: all
  roles:
  - role: flynn_backup
    flynn_backup_username: flynnbackups
    flynn_backup_clusters:
    # Back up the "cluster0" cluster every hour.
    - name: cluster0
      minute: 0
    flynn_backup_aws:
      access_key_id: key
      secret_access_key: secret
    flynn_backup_s3_bucket_name: bucketname
    flynn_backup_sentry_dsn: https://example.sentry.io/123
```

## Dependencies

None

## License

BSD

## Author Information

[Robin Daugherty](https://github.com/RobinDaugherty)
