# RepoReport
A simple Bash script to display the number of Git commits made date-wise for a
directory containing bare git repositories.

## Installation
Copy the script to `PATH`. For ease of use, remove the `.sh` file extension.

## Usage
```
reporeport GIT_BARE_PATH [OPTIONS]

GIT_BARE_PATH
  Git repository bare directory path
```

### Options
```
  -h    --help           Display this help message
  -v    --version        Display version information
  -t    --temp   <dir>   Specify temporary directory (Default: /tmp)
  -o    --output <file>  Specify data output file (Default: /tmp/reporeport.dat)

```

### Examples

- `reporeport /path/to/git/bare/repo`
- `reporeport -t /path/to/temp/dir -o output_file`

## License
MIT License. Read [License](LICENSE.txt) for more information.

