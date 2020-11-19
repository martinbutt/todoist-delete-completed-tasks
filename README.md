# Delete Completed Tasks - Todoist

This `bash` script allows you to delete your completed tasks from Todoist.

> **Note:** Completed Tasks are only available to **Todoist Premium** users.

## Usage
```
Usage: delete-completed-tasks.sh -t <token> [-b <backup_file> | -v]

Options:
  -t <token>         Your Todoist API token
  -b <backup_file>   Location of a backup file to append deleted tasks to (optional)
  -v                 Show verbose output (optional)
```

### Locating your Todoist API Token
Your API token will look something like `0123456789abcdef0123456789abcdef01234567`. You can find your token from the Todoist Web app under  `Todoist Settings -> Integrations -> API token`.

### Backing up your tasks
Before you begin, it is recommended to backup your tasks. While the completed tasks are not included in the backup, it is still recommended to backup your tasks. See https://get.todoist.help/hc/en-us/articles/115001799989-Backups

The script can backup the tasks it is deleting to a local file using the `-b` option

### Estimated run time
The Todoist API is limited in both batch size and requests per minute. In actual tests, the script deletes approximately 10 tasks per second.

### Sync conflicts
It is recommended to not use Todoist while the script is running, as this may result in sync conflicts and data loss.

