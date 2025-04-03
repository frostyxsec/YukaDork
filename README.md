# YukaDork

A command-line tool for automating Google Dork searches against a specific domain. Google Dorking is a technique that leverages Google's advanced search operators to find security vulnerabilities, exposed sensitive information, and more.

## Features

- 100+ pre-configured Google dork queries categorized by vulnerability/information type
- Colored output for better readability
- Progress tracking with percentage and progress bar
- Results saved to a markdown file for easy review
- Anti-detection measures to reduce the chance of being blocked by Google
- Multiple URL pattern extraction methods to maximize results

## Categories of Dork Queries

1. **Exposed Files & Directories** - Find publicly accessible files, backups, and directories
2. **Sensitive Credentials** - Discover exposed passwords, API keys, and authentication tokens
3. **Login Pages & Admin Panels** - Locate administrative interfaces and login portals
4. **Web Vulnerabilities** - Identify potential injection points and vulnerable parameters
5. **Sensitive Information** - Find confidential documents and data leakage
6. **Outdated Software & Services** - Detect old software versions that may have known vulnerabilities

## Installation

### Prerequisites

- Linux or macOS operating system
- `bash` shell
- `curl` and `grep` utilities
- `jq` (recommended but optional)

### Setup

1. Clone the repository or download the script:

```bash
git clone https://github.com/frostyxsec/YukaDork
cd YukaDork
```

2. Make the script executable:

```bash
chmod +x dork.sh
```

## Usage

Basic usage:

```bash
./dork.sh -d example.com -o results.txt
```

### Command-line options

- `-d <domain>`: Target domain to perform Google dorking on (required)
- `-o <output_file>`: Output file to save results (required)
- `-h`: Display help message

## Example

```bash
./dork.sh -d vulnerable-website.com -o vulnerable-website-results.md
```

## Output

The tool generates a Markdown file with:

- A timestamp of when the scan was performed
- Each dork query that was run
- Links to the resources found by each query
- Search URLs for manual verification when automated extraction fails

## Troubleshooting

### No Results Found

If you receive "No results found" for most or all queries:

1. Google may have detected automated searches and temporarily blocked your IP address
2. Try running fewer queries at once
3. Use a VPN or proxy to change your IP address
4. Add longer delays between queries by modifying the `sleep_time` variable
5. Use the saved Google search URLs to perform the searches manually

### Rate Limiting

To reduce the chance of being rate-limited:

1. Run the tool during off-peak hours
2. Modify the script to use longer delays between requests
3. Consider using a rotating proxy service for larger scans

## Best Practices

1. **Legal Compliance**: Only use this tool on domains you own or have explicit permission to test
2. **Ethical Use**: Don't use this tool to exploit vulnerabilities or access sensitive information without authorization
3. **Responsible Disclosure**: If you find security issues, report them to the domain owner through proper channels

## Disclaimer

This tool is provided for educational and legitimate security testing purposes only. The authors are not responsible for any misuse or damage caused by this tool. Use at your own risk and responsibility.

## License

This project is licensed under the GPL 3.0 License - see the LICENSE file for details.

## Acknowledgments

- Security researchers who have contributed Google dork queries
- Open-source community for valuable feedback and contributions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
