#!/usr/bin/swift

let bleu = "\u{001B}[0;34m"
let black = "\u{001B}[0;0m"

let titleInput = CommandLine.arguments[1]
let title = "==  \(titleInput)  =="
let border = String(repeating: "=", count: title.count)

func prettyPrint(_ msg: String) {
  print(bleu + msg + black)
}

prettyPrint(border)
prettyPrint(title)
prettyPrint(border)
