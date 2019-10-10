#!/usr/bin/swift

let titleInput = CommandLine.arguments[1]
let title = "== 🤖  \(titleInput)  =="
let border = String(repeating: "=", count: title.count)

let color = "\u{001B}[0;34m"
let end = "\u{001B}[0;0m"
print(color + border)
print(title)
print(border + end)
