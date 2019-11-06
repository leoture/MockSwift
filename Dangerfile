@CHANGELOG_FILE = "CHANGELOG.md"
@PULL_REQUEST_TEMPLATE = ".github/PULL_REQUEST_TEMPLATE.md"

has_source_changes = !git.modified_files.grep(/^Sources/).empty?
has_test_changes = !git.modified_files.grep(/^Tests/).empty?
has_changelog_changes = git.modified_files.include?("CHANGELOG.md")
has_pr_body = !github.pr_body.strip.empty?
has_linuxmain_changes = system("./scripts/check-linux-tests.sh")

if has_source_changes && !has_changelog_changes
    fail("Please update #{github.html_link(@CHANGELOG_FILE)}.")
end

if has_source_changes && !has_test_changes
  warn("Source files changed but tests have not been update."\
       "Please update tests if behavior has been update.")
end

if !has_pr_body
  warn("Please, provide a description to your PR. #{github.html_link(@PULL_REQUEST_TEMPLATE)} can help you.")
end

if !has_linuxmain_changes
  fail("linuxmain have not been update. Please run `swift test --generate-linuxmain`.")
end
