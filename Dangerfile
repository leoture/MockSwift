@CHANGELOG_FILE = "CHANGELOG.md"
@PULL_REQUEST_TEMPLATE = ".github/PULL_REQUEST_TEMPLATE.md"

has_source_changes = !git.modified_files.grep(/^Sources/).empty?
has_test_changes = !git.modified_files.grep(/^Tests/).empty?
has_changelog_changes = git.modified_files.include?("CHANGELOG.md")
has_pr_body = !github.pr_body.strip.empty?

if github.pr_title.include?("WIP") || github.pr_title.include?("wip")
    warn "🚧 PR is classed as Work in Progress, this should not be merged."
end

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

def manifests_size
  lines = File.readlines("Tests/MockSwiftTests/XCTestManifests.swift")
  lines.join.size
end

previous_size = manifests_size
system("swift test --generate-linuxmain")
current_size = manifests_size

has_linuxmain_changes = previous_size == current_size

if !has_linuxmain_changes
  fail("XCTestManifests.swift has not been updated. Please run `swift test --generate-linuxmain` to include all tests in linux CI.")
end

swiftformat.check_format

swiftlint.verbose = true
swiftlint.lint_files(inline_mode: true)
