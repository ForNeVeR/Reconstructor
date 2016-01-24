Reconstructor
=============

A tool to recreate history based on partial information.

Basic usage
-----------

The basic use case applies if you have a set of timestamped backup directories
and want to import them all to a new git repository.

First of all, prepare the backups: put them all to a single directory and tidy
up the backup naming scheme: every backup should be named
`<anything>_timestamp`. Also consider deleting any redundant files at this
moment.

You should have a file system structure like the following:

    backup_home
    ├project_20150101103000
    │└project-name
    │ ├file1.txt
    │ └file2.txt
    └project_20150102120000
     └project-name
      ├file1.txt
      └file2.txt

`project-name` directory inside every backup is optional; Reconstructor supports
stripping constant names like that from the resulting repository structure.

If you have a structure like that, invoke the Reconstructor script in your
PowerShell session:

    Initialize-GitFromDirectoryBackup `
        -BackupDirectory backup_home `
        -Target /where-to-put-git-repository `
        -StripPath 'project-name' `
        -DateTimeFormat 'yyyyMMddHHmmss'

`StripPath` and `DateTimeFormat` arguments are optional. If `StripPath` is not
defined, then path shortening will not be performed. The default for
`DateTimeFormat` is `'yyyyMMddHHmmss'`. This format should be conformant with
the [standard .NET date and time format conventions][dotnet-date-time-format].

Licensing
---------

Copyright © 2016 Friedrich von Never <friedrich@fornever.me>

This software may be used under the terms of the MIT license, see `License.md`
for details.

[dotnet-date-time-format]: https://msdn.microsoft.com/en-us/library/8kb3ddd4(v=vs.110).aspx
